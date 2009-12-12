module Platter
  module Cucumber
    module Formatter

      module ScenarioFormatter

        def self.included(obj)
          obj.send(:include, InstanceMethods)
        end

        module InstanceMethods

          def to_cucumber_file_format
            ["Scenario: #{title}", steps.collect { |step| "  #{step.to_cucumber_file_format}" }].join("\n")
          end

        end

      end

    end
  end
end
