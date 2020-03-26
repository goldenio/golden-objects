# frozen_string_literal: true

require 'golden/attribute_accessors'

module Golden
  class ApplicationContext
    class << self
      def attributes
        accessor_attributes
      end

      def permits
        @permits ||= lambda do
          attrs = attributes.clone
          attrs
        end.call
      end
    end

    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations
    include Golden::ExtendedAttrAccessor
    include Golden::BooleanAccessor
    include Golden::DateTimeAccessor

    def initialize(accessors = {})
      assign_attributes(accessors || {})
    end

    def perform
      raise NotImplementedError
    end
  end
end
