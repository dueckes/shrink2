module Shrink
  module Cucumber
    module Formatter

      module TableFormatter

        def self.included(obj)
          obj.send(:include, InstanceMethods)
        end

        module InstanceMethods

          def to_cucumber_file_format
            rows_with_padded_cell_text.collect { |row_cell_texts| "| #{row_cell_texts.join(" | ")} |" }.join("\n")
          end

        end

      end

    end
  end
end
