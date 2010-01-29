module Shrink
  module Cucumber
    module Formatter

      module StepFormatter

        def self.included(obj)
          obj.send(:include, InstanceMethods)
        end

        module InstanceMethods

          def to_cucumber_file_format
            text_type? ? text : table.to_cucumber_file_format.lpad_lines(2)
          end

        end

      end

    end
  end
end
