# frozen_string_literal: true

module Golden
  class QueryForm < Golden::ApplicationForm
    class << self
      def attributes
        accessor_attributes
      end

      def permits
        @permits ||= lambda do
          attrs = attributes.clone
          attrs.uniq
        end.call
      end
    end

    attr_reader :result
    attr_accessor :per, :page, :sort
    attr_accessor :mode

    def initialize(params, accessors = {})
      @query_params = find_query_from(params)
      assign_attributes(strip_attributes(@query_params))
      assign_attributes(strip_attributes(accessors || {}))
      @per ||= params.dig(:per)
      @page ||= params.dig(:page)
      @sort ||= params.dig(:sort)
      @mode ||= :paginated
    end

    def save
      return false if invalid?

      query!
      errors.empty?
    end

    private

    def find_query_from(params)
      if ::Object.const_defined?('ActionController') && params.is_a?(ActionController::Parameters)
        params.require(:query).permit(*self.class.permits)
      else
        params.dig(:query)&.slice(*self.class.permits) || {}
      end
    rescue ActionController::ParameterMissing
      {}
    end

    def query_accessors
      attrs = attributes.clone
      attrs.delete(:mode)
      attrs.each { |accessor, value| attrs.delete(accessor) if value.blank? }
      attrs
    end

    def query!
      raise NotImplementedError
    end
  end
end
