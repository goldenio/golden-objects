# frozen_string_literal: true

require 'yaml'

module Golden
  module YamlCoderConcern
    extend ActiveSupport::Concern

    class_methods do
      def load(yaml)
        obj = YAML.safe_load(yaml, [Symbol]) if yaml.is_a?(String) && /^---/.match?(yaml)
        obj.is_a?(Hash) ? new(obj || {}) : obj
      end

      def dump(obj)
        return if obj.nil?

        if obj.respond_to? :to_h
          YAML.dump obj.to_h
        else
          assert_valid_value(obj, action: 'dump')
          YAML.dump obj
        end
      end

      private

      def assert_valid_value(obj, action:)
        return if obj.nil? || obj.is_a?(self)

        error = %(
          can't #{action}: was supposed to be a #{name},
          but was a #{obj.class.name}. -- #{obj.inspect}
        ).gsub(/\s+/, ' ').strip

        if ::Object.const_defined? 'ActiveRecord'
          raise ::ActiveRecord::SerializationTypeMismatch, error
        else
          raise ::Golden::Objects::Error, error
        end
      end
    end
  end
end
