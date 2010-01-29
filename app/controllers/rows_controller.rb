class RowsController < ApplicationController
  include CrudApplicationControllerAddAnywhereTableSupport

  def add
    @position = params[:position]
    @table_presenter = TablePresenter.new(params[:table_dom_id], self)
    @table_presenter.create_row_presenter(Shrink::Row.new_with_cells(params[:number_of_columns]))
  end

  def remove
    @position = params[:position]
    @table_dom_id = params[:table_dom_id]
  end

end
