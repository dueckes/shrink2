module Shrink
  module Cucumber
    module Ast

      module Scenario

        def self.included(scenario)
          scenario.send(:include, InstanceMethods)
          scenario.instance_eval { attr_reader :steps }
        end

        module InstanceMethods

          def tag_names
            @tags.names
          end

        end

      end

    end
  end
end
