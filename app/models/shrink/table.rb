module Shrink

  class Table < ::ActiveRecord::Base
    include Shrink::Cucumber::Formatter::TableFormatter
    include Shrink::Cucumber::Adapter::AstTableAdapter

    has_many :rows, :class_name => "Shrink::Row", :order => :position, :dependent => :destroy

    class << self

      def new_empty
        table = self.new
        2.times { table.add_empty_row }
        table
      end

      def create_with_dimensions_and_texts!(dimensions, texts)
        table = self.create!
        (1..dimensions[:rows]).each do |row_number|
          starting_text_position = (row_number - 1) * dimensions[:columns]
          table.create_row!(texts[starting_text_position, dimensions[:columns]])
        end
        table
      end

    end

    def add_empty_row
      self.rows << (row = Shrink::Row.new(:table => self))
      row.cells << Shrink::Cell.new(:row => row, :text => "")
    end

    def create_row!(cell_texts)
      self.rows << (row = Shrink::Row.create!(:table => self))
      row.update_cells!(cell_texts)
    end

    def update_with_dimensions_and_texts!(dimensions, texts)
      (rows.count - dimensions[:rows]).times { rows.last.destroy }
      (dimensions[:rows] - rows.count).times { self.rows << Shrink::Row.create!(:table => self) }
      rows.each_with_index { |row, i| row.update_cells!(texts[i * dimensions[:columns], dimensions[:columns]]) }
    end

    def header_row
      rows[0]
    end

    def data_rows
      rows[1..-1]
    end

    def calculate_summary
      rows.collect { |row| "|#{row.cells.collect(&:text).join("|")}|" }.join("\n")
    end

    def rows_with_padded_cell_text
      column_widths = determine_column_widths
      rows.collect do |row|
        column_widths.collect_with_index do |width, column_number|
          row.cells[column_number].text.ljust(width)
        end
      end
    end

    private
    def number_of_columns
      header_row.cells.size
    end

    def columns
      (0..number_of_columns - 1).collect do |column_position|
        rows.collect { |row| row.cells[column_position] }
      end
    end

    def determine_column_widths
      columns.collect { |column| column.collect { |cell| cell.text.length }.sort.last }
    end

  end

end
