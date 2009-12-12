module Platter
  module Cucumber
    module Formatter

      module FeatureFormatter

        def self.included(obj)
          obj.send(:include, InstanceMethods)
        end

        module InstanceMethods

          def to_cucumber_file_format
            tag_line = tags.collect(&:to_cucumber_file_format).join(" ")
            formatted_description_lines = description_lines.collect { |line| "  #{line.to_cucumber_file_format}" }
            feature_header = [tag_line, "Feature: #{title}", formatted_description_lines].flatten.delete_if(&:empty?).join("\n")
            [feature_header].concat(scenarios.collect(&:to_cucumber_file_format)).join("\n\n")
          end

        end

      end

    end
  end
end
