module Shrink
  module ActionView
    module Helpers
      module ScriptaculousHelper

        def self.included(helper)
          helper.instance_eval do
            include InstanceMethods
            alias_method_chain :visual_effect, :remove_support
          end
        end

        module InstanceMethods

          def visual_effect_with_remove_support(name, element_id = false, js_options = {})
            remove_match = name.to_s.match(/^(.*)_and_remove$/)
            resolved_name = remove_match ? remove_match[1].to_sym : name
            resolved_js_options = remove_match ? { :afterFinish => "function() { $('##{element_id}').remove() }" } : {}
            resolved_js_options.merge!(js_options)
            visual_effect_without_remove_support(resolved_name, element_id, resolved_js_options)
          end

        end

      end
    end
  end
end
