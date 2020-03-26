# frozen_string_literal: true

module Golden
  module EnumAccessor
    extend ActiveSupport::Concern

    class_methods do
      def enum_accessor(*attributes, model:)
        [*attributes].uniq.each do |attribute_name|
          plural_name = attribute_name.to_s.pluralize
          model = model.constantize unless model.is_a?(Class)

          attr_accessor attribute_name

          define_singleton_method(plural_name) do
            alias_name = "#{plural_name}_alias"
            values = model.send(plural_name).clone
            values.merge!(model.send(alias_name)) if model.respond_to?(alias_name)
            values
          end

          class_eval do
            define_method("#{attribute_name}=") do |value|
              enum_value = self.class.send(plural_name)[value]
              enum_key = model.send(plural_name).key(enum_value)
              instance_variable_set("@#{attribute_name}", enum_key)
            end
          end
        end
      end
    end
  end
end
