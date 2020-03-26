# frozen_string_literal: true

require 'golden/attribute_accessors'

module Golden
  class ApplicationTransformer
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include Golden::BooleanAccessor
    include Golden::DateTimeAccessor

    def initialize(params, accessors = {})
      @params = params
      assign_attributes(accessors || {})
    end

    def perform
      raise NotImplementedError
    end
  end
end
