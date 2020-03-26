# frozen_string_literal: true

module Golden
  module ExtendedAttrAccessor
    extend ActiveSupport::Concern

    included do
      class_attribute :attribute_accessors, instance_accessor: false, default: []
    end

    class_methods do
      def attr_accessor(*attrs)
        self.attribute_accessors += attrs.map(&:to_sym)
        self.attribute_accessors.uniq!
        super(*attrs)
      end

      def accessor_attributes
        @accessor_attributes ||= attribute_accessors.dup
      end
      alias_method :attributes, :accessor_attributes unless respond_to? :attributes

      private

      def merge_attributes!(*attrs)
        accessor_attributes.concat(attrs.map(&:to_sym)).uniq!
      end

      def delete_attributes!(*attrs)
        attrs.each { |attr| accessor_attributes.delete(attr) }
      end
    end

    # NOTE: conflict with ActiveModel::Attributes#attributes
    def attributes
      self.class.attributes.inject({}) do |hash, attribute|
        hash.merge(attribute => public_send(attribute))
      end.with_indifferent_access
    end

    def strip_attributes(attrs)
      attrs.transform_values do |value|
        value.respond_to?(:strip) ? value.strip : value
      end
    end

    def strip_attributes!(attrs)
      attrs.transform_values do |value|
        value.respond_to?(:strip!) ? value.strip! : value
      end
    end
  end
end
