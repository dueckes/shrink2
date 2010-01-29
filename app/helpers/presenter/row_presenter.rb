class RowPresenter < ApplicationPresenter
  attr_reader :table_presenter, :cell_presenters

  def initialize(row, table_presenter, controller)
    super(row, controller)
    @table_presenter = table_presenter
    @cell_presenters = []
    add_initial_cell_presenters
  end

  def add_row_url
    @table_presenter.add_row_url
  end

  def remove_row_url
    @table_presenter.remove_row_url
  end

  def create_cell_presenter(cell)
    @cell_presenters << CellPresenter.new(cell, self, controller)
  end

  private
  def add_initial_cell_presenters
    @row.cells.each { |cell| create_cell_presenter(cell) }
  end

end
