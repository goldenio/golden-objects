# frozen_string_literal: true

module Golden
  module RejectedAtConcern
    extend ActiveSupport::Concern

    included do
      scope :not_rejected, -> { where(rejected_at: nil) }
      scope :rejected, -> { where.not(rejected_at: nil) }
    end

    def cancel_reject!
      update rejected_at: nil, rejected_by: nil
    end

    def rejected?
      rejected_at?
    end

    def not_rejected?
      !rejected?
    end
  end
end
