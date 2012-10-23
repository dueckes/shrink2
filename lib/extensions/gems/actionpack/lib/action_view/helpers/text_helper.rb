module Shrink
  module ActionView
    module Helpers
      module TextHelper

        def self.included(helper)
          helper.instance_eval do
            include InstanceMethods
            alias_method_chain :simple_format, :space_support
            alias_method_chain :textilize, :table_whitespace_support
          end
        end

        module InstanceMethods

          def simple_format_with_space_support(text, html_options={})
            formatted_text = text.gsub(/ /, "&nbsp;")
            simple_format_without_space_support(formatted_text, html_options)
          end

          def textilize_with_table_whitespace_support(text)
            adjusted_text = text.gsub(/\A([^\|]*[^\n])\n\|/, "\\1\n\n|").gsub(/\A\n*\|/, "|")
            textilize_without_table_whitespace_support(adjusted_text)
          end

        end

      end
    end
  end
end
