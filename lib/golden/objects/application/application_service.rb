# frozen_string_literal: true

require 'golden/attribute_accessors'

module Golden
  class ApplicationService
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    def run
      raise NotImplementedError
    end
  end
end
