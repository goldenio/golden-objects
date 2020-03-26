# frozen_string_literal: true

module Golden
  module DatepickerConcern
    extend ActiveSupport::Concern

    class_methods do
      def permit_datepicker_of(fields, attrs)
        fields.each do |field|
          attrs.delete(field)
          attrs.push(field => [])
        end
      end
    end

    def filter_dates_of_datepicker(fields, attrs)
      fields.each do |field|
        dates = attrs.delete(field)
        attrs[field] = date_of_datepicker(dates)
      end
    end

    def filter_duration_of_datepicker(field, attrs)
      return [] unless attrs.key? field

      dates = attrs.delete(field)
      duration_of_datepicker(dates)
    end

    private

    def date_of_datepicker(values)
      values.is_a?(Array) ? (values.first || '') : values
    end

    def duration_of_datepicker(values)
      first_date = values.is_a?(Array) ? (values.first || '') : values
      last_date = values.is_a?(Array) && values.size > 1 ? (values.last || '') : ''
      [first_date, last_date]
    end
  end
end
