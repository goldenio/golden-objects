# frozen_string_literal: true

require 'golden/attribute_accessors'

module Golden
  class ApplicationCalculator
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations
    include Golden::BooleanAccessor

    def initialize(accessors = {})
      assign_attributes(accessors || {})
    end

    def perform
      raise NotImplementedError
    end

    private

    def parse_decimal(value)
      return value.to_d if value.respond_to? :to_d

      BigDecimal(value.presence || 0)
    rescue ArgumentError
      BigDecimal(0)
    end
  end
end
