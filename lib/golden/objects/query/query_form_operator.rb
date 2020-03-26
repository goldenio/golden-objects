# frozen_string_literal: true

module Golden
  class QueryFormOperator < Golden::ApplicationOperator
    class << self
      # rubocop:disable Naming/PredicateName
      def has_query_form(form: nil, form_presenter: nil, result_presenter: nil)
        define_method :form_class do
          return form.to_s.constantize if form.present?

          "#{self.class.parent.name}::QueryForm".constantize
        end

        define_method :form_presenter_class do
          return form_presenter.to_s.constantize if form_presenter.present?

          "#{self.class.parent.name}::QueryFormPresenter".constantize
        end

        define_method :result_presenter_class do
          return result_presenter.to_s.constantize if result_presenter.present?

          "#{self.class.parent.name}::QueryResultPresenter".constantize
        end
      end
      # rubocop:enable Naming/PredicateName
    end

    extend ActiveModel::Callbacks

    define_model_callbacks :build_form

    attr_reader :params, :form

    def initialize(params, accessors = {})
      @params = params
      assign_attributes(accessors || {})
      run_callbacks(:build_form) { @form ||= build_form }
    end

    def perform
      form.save
      errors.merge! form.errors
      errors.empty?
    end

    def form_presenter
      @form_presenter ||= form_presenter_class.new form
    end

    def result_presenter
      @result_presenter ||= result_presenter_class.collect form.result
    end

    private

    def query_params
      params
    end

    def build_form
      form_accessors = send(:query_accessors) if private_methods.include? :query_accessors
      form_class.new query_params, form_accessors
    end
  end
end
