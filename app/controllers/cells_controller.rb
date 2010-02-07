class CellsController < ApplicationController
  include ResourceApplicationControllerAddAnywhereTableSupport

  def add_column
    @position = params[:position]
    @table_presenter = TablePresenter.new(params[:table_dom_id], self)
    (1..params[:number_of_rows]).each { @table_presenter.create_row_presenter(Shrink::Row.new_with_cells(1)) }
  end

  def remove_column
    @position = params[:position]
    @table_dom_id = params[:table_dom_id]
  end

end
