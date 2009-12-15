module Platter
  module ActionView
    module Helpers
      module TextHelper

        def self.included(helper)
          helper.instance_eval do
            include InstanceMethods
            alias_method_chain :simple_format, :space_support
          end
        end

        module InstanceMethods

          def simple_format_with_space_support(text, html_options={})
            formatted_text = text.gsub(/ /, "&nbsp;")
            simple_format_without_space_support(formatted_text, html_options)
          end

        end

      end
    end
  end
end
