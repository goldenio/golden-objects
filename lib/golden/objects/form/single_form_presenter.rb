# frozen_string_literal: true

module Golden
  class SingleFormPresenter < Golden::ApplicationPresenter
    class << self
      def form_accessors(permits)
        accessors = permits.reject do |permit|
          %w[Symbol String].exclude? permit.class.name
        end
        attr_accessor(*accessors)
      end
    end

    # include Rails.application.routes.url_helpers

    attr_reader :form

    delegate :errors, :valid?, to: :form

    def initialize(form, accessors = {})
      assign_form_attributes(form, excludes: excluded_form_accessors)
      assign_attributes(accessors || {})
    end

    def assign_form_attributes(form, excludes: [])
      @form = form
      accessors = form.class.permits.reject { |permit| excludes.include?(permit) }
      self.class.form_accessors accessors
      assign_attributes form.attributes.slice(*accessors)
    end

    def excluded_form_accessors
      []
    end

    def persisted?
      false
    end
  end
end
