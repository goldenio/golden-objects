# frozen_string_literal: true

require 'golden/attribute_accessors/extended_attr_accessor'
require 'golden/attribute_accessors/boolean_accessor'
require 'golden/attribute_accessors/date_time_accessor'
require 'golden/attribute_accessors/enum_accessor'

module Golden
  module AttributeAccessors
    class << self
      def default_zone
        return ::Rails.application.config.time_zone if ::Object.const_defined? 'Rails'

        'UTC'
      end
    end
  end
end
