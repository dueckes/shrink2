module Shrink
  module Cucumber
    module Ast

      module Tags

        def self.included(tags)
          tags.send(:include, InstanceMethods)
        end

        module InstanceMethods

          def names
            @tags.collect(&:name)
          end

        end

      end

    end
  end
end
