# frozen_string_literal: true

require 'golden/attribute_accessors'

module Golden
  class ApplicationGenerator
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations

    def initialize(accessors = {})
      assign_attributes(accessors || {})
    end

    def perform
      raise NotImplementedError
    end
  end
end
