# frozen_string_literal: true

require 'active_support/time_with_zone'

module Golden
  module DateTimeAccessor
    extend ActiveSupport::Concern

    class_methods do
      # rubocop:disable Metrics/CyclomaticComplexity
      def datetime_accessor(*attributes, date_only: false)
        [*attributes].uniq.each do |attribute_name|
          attr_accessor attribute_name

          class_eval do
            define_method("#{attribute_name}?") do
              instance_variable_get("@#{attribute_name}")
            end

            define_method("#{attribute_name}=") do |value|
              case value
              when ActiveSupport::TimeWithZone
                time = value
              when Date, Time, DateTime
                time = value
              when String
                time = parse_time(value)
              when NilClass
                time = nil
              else
                raise "#{value.class} is unsupported!"
              end
              time = time.to_date if time && date_only
              instance_variable_set("@#{attribute_name}", time)
            end
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      def date_accessor(*attributes)
        datetime_accessor(*attributes, date_only: true)
      end
    end

    def parse_time(string, zone: Golden::AttributeAccessors.default_zone)
      ActiveSupport::TimeZone.new(zone)&.parse(string)
    rescue StandardError
      nil
    end
  end
end
