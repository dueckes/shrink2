class TablePresenter < ApplicationPresenter
  attr_reader :row_presenters

  def initialize(table_or_dom_id, controller)
    super(table_or_dom_id, controller)
    @row_presenters = []
    add_initial_row_presenters if @table
  end

  def form_class
    model.new_record? ? "add_anywhere" : "edit"
  end

  def last_column_controls_cell_dom_id
    "#{dom_id}_last_column_controls_cell"
  end

  def column_controls_row_dom_id
    "#{dom_id}_column_controls_after_last"
  end

  def last_row_controls_row_dom_id
    "#{dom_id}_last_row_controls_row"
  end

  def add_row_url
    url_for(:controller => :rows, :action => :add, :table_dom_id => dom_id)
  end

  def remove_row_url
    url_for(:controller => :rows, :action => :remove, :table_dom_id => dom_id)
  end

  def add_column_url
    url_for(:controller => :cells, :action => :add_column, :table_dom_id => dom_id)
  end

  def remove_column_url
    url_for(:controller => :cells, :action => :remove_column, :table_dom_id => dom_id)
  end

  def header_row_presenter
    @row_presenters[0]
  end

  def data_row_presenters
    @row_presenters[1..-1]
  end

  def create_row_presenter(row)
    @row_presenters << RowPresenter.new(row, self, controller)
  end

  private
  def add_initial_row_presenters
    @table.rows.each { |row| create_row_presenter(row) }
  end

end
