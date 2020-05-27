# frozen_string_literal: true

require 'golden/attribute_accessors'

module Golden
  class ApplicationPresenter
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::AttributeAssignment

    def initialize(accessors = {})
      assign_attributes(accessors || {})
    end
  end
end
