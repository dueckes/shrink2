module Platter
  module Cucumber
    module Ast

      module Scenario

        def self.included(scenario)
          scenario.instance_eval do
            attr_reader :steps
          end
        end

      end

    end
  end
end
