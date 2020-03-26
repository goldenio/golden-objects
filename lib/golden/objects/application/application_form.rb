# frozen_string_literal: true

require 'golden/attribute_accessors'
require 'golden/active_model_concerns'

module Golden
  class ApplicationForm
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

    extend ActiveModel::Callbacks
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include ActiveModel::Conversion
    include Golden::ExtendedAttrAccessor
    include Golden::BooleanAccessor
    include Golden::DateTimeAccessor
    include Golden::EnumAccessor

    define_model_callbacks :save

    def initialize(accessors = {})
      assign_attributes(strip_attributes(accessors || {}))
    end

    def save
      raise NotImplementedError
    end
  end
end
