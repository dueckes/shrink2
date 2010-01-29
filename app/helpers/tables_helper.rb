module TablesHelper

  def new_table_js (presenter)
    table_presenter = presenter.respond_to?(:table_presenter) ? presenter.table_presenter : presenter
    "new Table('##{table_presenter.dom_id}')"
  end

end
