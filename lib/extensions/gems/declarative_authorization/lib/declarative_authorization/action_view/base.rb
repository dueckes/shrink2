module Shrink
  module DeclarativeAuthorization
    module ActionView

      module Base

        def self.included(base)
          base.extend(ClassMethods)
          base.send(:include, InstanceMethods)
          base.add_declarative_authorization_support_to(:render, :content_tag, :content_tag_for,
                                                        :link_to, :link_to_remote, :link_to_function)
        end

        module ClassMethods

          def add_declarative_authorization_support_to(*methods)
            methods.each do |method|
              self.class_eval <<-CODE
                def #{method}_with_declarative_authorization_support(*args, &block)
                  invoke_with_declarative_authorization_support(:#{method}_without_declarative_authorization_support, *args, &block)
                end
              CODE
              alias_method_chain method, :declarative_authorization_support
            end
          end

        end

        module InstanceMethods

          def invoke_with_declarative_authorization_support(method, *args, &block)
            if args.last.is_a?(Hash) && args.last[:when_permitted_to]
              authorization_hash = args.pop
              permitted_to?(*authorization_hash[:when_permitted_to]) ?
                      self.send(method.to_sym, *args, &block) : 
                      render_text(authorization_hash[:otherwise] || "", &block)
            else
              self.send(method.to_sym, *args, &block)
            end
          end

          private
          def render_text(text, &block)
            block && block_called_from_erb?(block) ? concat(text) :text
          end

        end

      end
    end
  end
end
