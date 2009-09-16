module Platter
  module Cucumber
    module Ast

      module ScenarioConverter

        def self.included(obj)
          obj.extend(ClassMethods)
        end

        module ClassMethods

          def set_step_converter(converter)
            @step_converter = converter
          end

          def step_converter
            raise "step_converter must be established" if !@step_converter
            @step_converter
          end

          def from(cucumber_ast_scenario)
            scenario = Platter::Scenario.new(:title => cucumber_ast_scenario.name)
            cucumber_ast_scenario.steps.each do |cucumber_ast_step|
              scenario.steps << step_converter.from(cucumber_ast_step)
            end
            scenario
          end

        end

      end

    end
  end
end
