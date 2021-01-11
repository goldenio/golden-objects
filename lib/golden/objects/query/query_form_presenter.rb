# frozen_string_literal: true

module Golden
  class QueryFormPresenter < Golden::SingleFormPresenter
    delegate :result, to: :form

    def query_url
      raise NotImplementedError
    end
  end
end
