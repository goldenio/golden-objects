# frozen_string_literal: true

module Golden
  class FormBuilder < ActionView::Helpers::FormBuilder
    def label(method, text = nil, options = {}, &block)
      text ||= I18n.t("helpers.label.#{object.model_name.i18n_key}.#{method}")
      super(method, text, options, &block)
    end
  end
end
