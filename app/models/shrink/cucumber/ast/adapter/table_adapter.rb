module Shrink
  module Cucumber
    module Ast
      module Adapter

        module TableAdapter

          def self.included(obj)
            obj.extend(ClassMethods)
          end

          module ClassMethods

            def adapt(cucumber_ast_table)
              table = Shrink::Table.new
              cucumber_ast_table.raw.each do |raw_row|
                table.rows << (row = Shrink::Row.new)
                raw_row.each { |raw_cell| row.cells << Shrink::Cell.new(:text => raw_cell) }
              end
              table
            end

          end

        end

      end
    end
  end
end
