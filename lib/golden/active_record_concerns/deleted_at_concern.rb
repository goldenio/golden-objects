# frozen_string_literal: true

module Golden
  module DeletedAtConcern
    extend ActiveSupport::Concern

    included do
      scope :undeleted, -> { where(deleted_at: nil) }
      scope :deleted, -> { where.not(deleted_at: nil) }
    end

    def soft_destroy!
      update deleted_at: Time.zone.now
    end

    def deleted?
      deleted_at?
    end

    def undeleted?
      !deleted?
    end
  end
end
