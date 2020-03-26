# frozen_string_literal: true

module Golden
  class QueryResultPresenter < Golden::ApplicationPresenter
    include Enumerable

    attr_reader :records, :presenters

    def initialize(records, presenter_class)
      @records = records
      @presenters = records.map { |record| presenter_class.constantize.new record }
    end

    def each(&block)
      presenters.each(&block)
    end

    def total_count
      records.total_count
    end

    def current_page
      records.current_page
    end

    def per_page
      records.limit_value
    end
  end
end
