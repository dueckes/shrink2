module Shrink
  module Cucumber
    module Ast
      module Adapter

        module ScenarioAdapter

          def self.included(obj)
            obj.extend(ClassMethods)
            obj.mandatory_cattr_accessor :step_adapter, :tag_adapter
          end

          module ClassMethods

            def adapt(cucumber_ast_scenario)
              scenario = Shrink::Scenario.new(:title => cucumber_ast_scenario.name)
              scenario.steps.concat(
                      cucumber_ast_scenario.steps.collect { |cucumber_ast_step| step_adapter.adapt(cucumber_ast_step) })
              scenario.tags.concat(
                      cucumber_ast_scenario.tag_names.collect { |tag_name| tag_adapter.adapt(tag_name) })
              scenario
            end

          end

        end

      end
    end
  end
end
