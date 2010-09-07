module Shrink
  module Cucumber
    module Adapter

      module AstStepAdapter

        def self.included(obj)
          obj.extend(ClassMethods)
        end

        module ClassMethods

          def set_table_adapter(adapter)
            @table_adapter = adapter
          end

          def table_adapter
            raise "table_adapter must be established" if !@table_adapter
            @table_adapter
          end

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
