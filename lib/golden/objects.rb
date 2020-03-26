# frozen_string_literal: true

require 'active_support'
require 'active_model'
require 'active_record'

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

require 'golden/objects/form/action_form_operator'
require 'golden/objects/form/active_record_form'
require 'golden/objects/form/single_form_presenter'

require 'golden/objects/query/query_context'
require 'golden/objects/query/query_form'
require 'golden/objects/query/query_form_operator'
require 'golden/objects/query/query_result_presenter'

module Golden
  module Objects
    class Error < StandardError; end
  end
end
