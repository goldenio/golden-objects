# frozen_string_literal: true

module Golden
  module HasPersistedRecordConcern
    extend ActiveSupport::Concern

    class_methods do
      # Outcome:
      #   * xxx_id
      #   * xxx_id=
      #   * xxx
      #   * xxx=
      #   * load_persisted_attributes_of_xxx_by
      #   * load_persisted_attributes_of_xxx
      #
      # Add validation if needed
      #   validates :xxx, presence: true
      #
      # rubocop:disable Naming/PredicateName
      def has_persisted_record(name, class_name: nil)
        class_name ||= name.to_s.classify
        klass = class_name.constantize
        attr_accessor "#{name}_id"
        attr_writer name

        define_method name do
          if instance_variable_get(:"@#{name}").blank?
            object = klass.find_by id: instance_variable_get(:"@#{name}_id")
            instance_variable_set(:"@#{name}", object) unless object.nil?
          end
          instance_variable_get(:"@#{name}")
        end

        define_method :"load_persisted_attributes_of_#{name}_by" do |id:|
          instance_variable_set(:"@#{name}_id", id)
          object = send(name)
          send(:"load_persisted_attributes_of_#{name}", object)
        end

        define_method :"load_persisted_attributes_of_#{name}" do |object|
          return {} if object.nil?

          instance_variable_set(:"@#{name}", object) if instance_variable_get(:"@#{name}").blank?

          attrs = object.attributes.symbolize_keys
          return attrs unless self.class.respond_to? :permits

          attrs.slice(*self.class.permits)
        end
      end
      # rubocop:enable Naming/PredicateName
    end
  end
end
