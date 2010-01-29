class CellPresenter < ApplicationPresenter
  attr_reader :row_presenter

  def initialize(cell, row_presenter, controller)
    super(cell, controller)
    @row_presenter = row_presenter
  end

  def column_controls_dom_id
    "#{dom_id}_column_controls_cell"
  end

  def text
    @cell.text
  end

  def tag_name
    table_presenter.header_row_presenter == @row_presenter ? "th" : "td"
  end

  def table_presenter
    @row_presenter.table_presenter
  end

end
