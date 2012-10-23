module CellsHelper

  def cell_tag(presenter, &block)
    content_tag(presenter.tag_name, { :id => presenter.dom_id }, &block)
  end

end
