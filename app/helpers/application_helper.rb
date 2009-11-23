# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Similiar to div_for but produces an li tag
  def li_for(record, *args, &block)
    content_tag_for(:li, record, *args, &block)
  end

  def pad_after_list(array)
    array.empty? ? "" : "<br style='clear:left;' /><br style='clear:left;' />"
  end

  def editable_text_link(text, options)
    link_to_remote text, { :method => :get }.merge(options), { :class => "editable-text-link", :title => "Click To Edit" }
  end

  def nested_dom_id(symbol, parent=nil)
    "#{dom_id(parent || @parent)}_#{symbol}"
  end

end
