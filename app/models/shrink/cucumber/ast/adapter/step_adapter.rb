module Shrink
  module Cucumber
    module Ast
      module Adapter

        module StepAdapter

          def self.included(obj)
            obj.extend(ClassMethods)
            obj.mandatory_cattr_accessor :table_adapter
          end

          module ClassMethods

            def adapt(cucumber_ast_step)
              steps = [Shrink::Step.new(:text => "#{cucumber_ast_step.keyword}#{cucumber_ast_step.name}")]
              if cucumber_ast_step.multiline_arg && cucumber_ast_step.multiline_arg.is_a?(::Cucumber::Ast::Table)
                steps << Shrink::Step.new(:table => table_adapter.adapt(cucumber_ast_step.multiline_arg))
              end
              steps
            end

          end

        end

      end
    end
  end
end
