# frozen_string_literal: true

module Golden
  class ActionFormOperator < Golden::ApplicationOperator
    class << self
      # rubocop:disable Naming/PredicateName
      def has_actions(actions, form: nil, presenter: nil)
        define_method :actions do
          actions
        end

        define_method :form_class do
          return form.to_s.constantize if form.present?

          "#{action.capitalize}Form".constantize
        end

        define_method :presenter_class do
          return presenter.to_s.constantize if presenter.present?

          "#{action.capitalize}FormPresenter".constantize
        end
      end
      # rubocop:enable Naming/PredicateName
    end

    extend ActiveModel::Callbacks

    attr_accessor :user, :form
    attr_accessor :params, :action

    validates :action, presence: true
    validates :form, presence: true

    define_model_callbacks :build_form
    define_model_callbacks :validate_form
    define_model_callbacks :save_form

    def initialize(params, accessors = {})
      @params = params
      @action = params[:action]&.to_sym
      assign_attributes(accessors || {})
      run_callbacks(:build_form) { @form ||= build_form }
    end

    def valid?(context = nil)
      super
      run_callbacks(:validate_form) { validate_form }
      errors.empty?
    end

    def perform
      return if invalid?

      run_callbacks(:save_form) { save_form }
      errors.empty?
    end

    def form_presenter
      @form_presenter ||= presenter_class.new(form)
    end

    private

    def build_form
      return if action.blank? || actions.exclude?(action)

      form_params = send("#{action}_params")
      form_accessors = send("#{action}_accessors") if private_methods.include? :"#{action}_accessors"
      form_class.new form_params.permit(*form_class.permits), form_accessors
    end

    def validate_form
      return unless form.present? && form.invalid?

      errors.merge! form.errors
    end

    def save_form
      form.save
      errors.merge! form.errors
    end
  end
end
