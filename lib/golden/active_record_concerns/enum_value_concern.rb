# frozen_string_literal: true

module Golden
  module EnumValueConcern
    extend ActiveSupport::Concern

    class_methods do
      def human_attribute_enum_value(attribute_name, value)
        return if value.blank?

        human_attribute_name("#{attribute_name}.#{value}")
      end

      def enum_options_for_select(attribute_name)
        enums = send(attribute_name.to_s.pluralize)
        enums.values.uniq.map do |value|
          key = enums.key(value)
          [human_attribute_enum_value(attribute_name, key), key]
        end.to_h
      end
    end

    def human_attribute_enum(attribute_name)
      self.class.human_attribute_enum_value(attribute_name, send(attribute_name))
    end
  end
end
