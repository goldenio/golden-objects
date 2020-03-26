# frozen_string_literal: true

require 'active_support'

require 'golden/objects/version'
require 'golden/attribute_accessors'
require 'golden/active_model_concerns'

module Golden
  module Objects
    class Error < StandardError; end
  end
end
