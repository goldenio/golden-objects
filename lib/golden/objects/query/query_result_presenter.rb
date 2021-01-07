# frozen_string_literal: true

module Golden
  class QueryResultPresenter < Golden::ApplicationPresenter
    class << self
      def collect(result, presenter_class)
        new(
          records: paginated_array(result),
          presenter_class: presenter_class
        )
      end

      def paginated_array(result)
        return result unless result.is_a?(Array)
        return result unless ::Object.const_defined? 'Kaminari'
        return Kaminari.paginate_array([], total_count: 0).page(1) if result.empty?

        Kaminari.paginate_array(result).page(1).per(result.size)
      end
    end

    include Enumerable

    attr_accessor :records, :presenter_class

    def each(&block)
      presenters.each(&block)
    end

    def presenters
      @presenters ||= records.map { |record| presenter_class.constantize.new record }
    end

    def total_count
      records.total_count
    end

    def total_page
      records.total_page
    end

    def current_page
      records.current_page
    end

    def per_page
      records.limit_value
    end
  end
end
