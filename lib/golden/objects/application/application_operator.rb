# frozen_string_literal: true

require 'golden/attribute_accessors'

module Golden
  class ApplicationOperator
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include Golden::DatepickerConcern

    def initialize(accessors = {})
      assign_attributes(accessors || {})
    end

    def perform
      raise NotImplementedError
    end
  end
end
