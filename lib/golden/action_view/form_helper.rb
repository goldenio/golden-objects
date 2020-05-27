# frozen_string_literal: true

module Golden
  module FormHelper
    def golden_form_with(**options, &block)
      model = options[:model]
      default_options = { builder: ::Golden::FormBuilder }
      default_options.merge!({ scope: :query, url: model.query_url }) if model.respond_to? :query_url
      form_with(**default_options.merge(options), &block)
    end
  end
end
