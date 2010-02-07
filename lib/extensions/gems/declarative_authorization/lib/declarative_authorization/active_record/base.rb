module Shrink
  module DeclarativeAuthorization
    module ActiveRecord

      module Base

        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods

          def decl_auth_context
            self.contextless_name.tableize.to_sym
          end

        end

      end

    end
  end
end
