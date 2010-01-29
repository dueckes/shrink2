module Shrink
  module Cucumber
    module Adapter

      module AstScenarioAdapter

        def self.included(obj)
          obj.extend(ClassMethods)
        end

        module ClassMethods

          def set_step_adapter(adapter)
            @step_adapter = adapter
          end

          def step_adapter
            raise "step_adapter must be established" if !@step_adapter
            @step_adapter
          end

          def adapt(cucumber_ast_scenario)
            scenario = Shrink::Scenario.new(:title => cucumber_ast_scenario.name)
            cucumber_ast_scenario.steps.each do |cucumber_ast_step|
              scenario.steps.concat(step_adapter.adapt(cucumber_ast_step))
            end
            scenario
          end

        end

      end

    end
  end
end
