module Shrink

  class Row < ::ActiveRecord::Base
    belongs_to :table, :class_name => "Shrink::Table"
    acts_as_list :scope => :table
    has_many :cells, :class_name => "Shrink::Cell", :order => :position, :dependent => :destroy

    TYPE_HEADER = "header".freeze
    TYPE_DATA = "data".freeze

    def self.new_with_cells(number_of_cells)
      row = self.new
      number_of_cells.times { row.cells << Shrink::Cell.new(:row => row) }
      row
    end

    def update_cells!(cell_texts)
      (cells.count - cell_texts.size).times { cells.last.destroy }
      (cell_texts.size - cells.count).times { cells.build }
      cells.each_with_index { |cell, i| cell.update_attributes!(:text => cell_texts[i])}
    end

    def row_type
      table.rows.first == self ? TYPE_HEADER : TYPE_DATA
    end

  end

end
