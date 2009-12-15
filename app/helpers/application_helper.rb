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

  def forgery_protection_request_parameter
    if respond_to?('protect_against_forgery?') && protect_against_forgery?
      "'#{request_forgery_protection_token}=' + encodeURIComponent('#{escape_javascript form_authenticity_token}')"
    else
      ""
    end
  end

  def draggable_link_remote_function(options)
    "if (!this.dragged) #{remote_function(options)}; this.dragged = false"
  end

end
