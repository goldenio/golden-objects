# frozen_string_literal: true

require 'active_support'
require 'active_model'

require 'golden/objects/version'
require 'golden/attribute_accessors'
require 'golden/active_model_concerns'
require 'golden/active_record_concerns'

require 'golden/objects/application/application_calculator'
require 'golden/objects/application/application_context'
require 'golden/objects/application/application_form'
require 'golden/objects/application/application_generator'
require 'golden/objects/application/application_operator'
require 'golden/objects/application/application_presenter'
require 'golden/objects/application/application_service'
require 'golden/objects/application/application_transformer'

module Golden
  module Objects
    class Error < StandardError; end
  end
end
