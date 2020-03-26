# frozen_string_literal: true

module Golden
  module DisabledAtConcern
    extend ActiveSupport::Concern

    included do
      scope :enabled, -> { where(disabled_at: nil) }
      scope :disabled, -> { where.not(disabled_at: nil) }
    end

    def disable!
      update disabled_at: Time.zone.now
    end

    def enable!
      update disabled_at: nil
    end

    def disabled?
      disabled_at?
    end

    def enabled?
      !disabled?
    end
  end
end
