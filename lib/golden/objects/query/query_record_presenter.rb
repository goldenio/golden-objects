# frozen_string_literal: true

module Golden
  class QueryRecordPresenter < Golden::ApplicationPresenter
    class << self
      def collect(records)
        ::Golden::QueryResultPresenter.collect(records, name)
      end
    end

    def initialize(record, accessors = {})
      super(accessors)
      @record = record
    end
  end
end
