# frozen_string_literal: true

module Golden
  module BooleanAccessor
    extend ActiveSupport::Concern

    TRUE_VALUES = [
      true, 1, '1',
      'true', 'TRUE', 'True', 't', 'T',
      'yes', 'YES', 'Yes', 'y', 'Y'
    ].freeze

    class_methods do
      def boolean_accessor(*attributes, allow_nil: false)
        [*attributes].uniq.each do |attribute_name|
          attr_accessor attribute_name

          class_eval do
            define_method("#{attribute_name}?") do
              instance_variable_get("@#{attribute_name}")
            end

            define_method("#{attribute_name}=") do |value|
              boolean = TRUE_VALUES.include?(value)
              boolean = nil if allow_nil && value.is_a?(String) && value.blank?
              boolean = nil if allow_nil && value.is_a?(NilClass)
              instance_variable_set("@#{attribute_name}", boolean)
            end
          end
        end
      end
    end
  end
end
