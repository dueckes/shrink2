# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Similar to div_for but produces an li tag
  def li_for(record, *args, &block)
    content_tag_for(:li, record, *args, &block)
  end

  def nested_dom_id(symbol, parent=nil)
    dom_id(parent || @parent, symbol)
  end

  def element_style(options)
    options[:hidden] ? "display: none;" : ""
  end

end
