module Platter
  module Cucumber
    module Ast

      module StepConverter

        def self.included(obj)
          obj.extend(ClassMethods)
        end

        module ClassMethods

          def from(cucumber_ast_step)
            Platter::Step.new(:text => "#{cucumber_ast_step.keyword} #{cucumber_ast_step.name}")
          end

        end

      end

    end
  end
end
