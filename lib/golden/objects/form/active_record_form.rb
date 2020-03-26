# frozen_string_literal: true

module Golden
  class ActiveRecordForm < Golden::ApplicationForm
    def initialize(params, accessors = {})
      assign_attributes(strip_attributes(params))
      assign_attributes(strip_attributes(accessors || {}))
    end

    def save
      return false if invalid?

      ::ActiveRecord::Base.transaction do
        run_callbacks(:save) { persist! }
      end
      errors.empty?
    end

    private

    def persist!
      raise NotImplementedError, <<~ERROR
        Please define #{__method__} like
        ```
          def #{__method__}
            return true if @order.save

            errors.merge! @order.errors
            false
          end
        ```
      ERROR
    end
  end
end
