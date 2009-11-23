module RootElementHelper

  def expand_root_element(page, options)
    page.replace_html("#{dom_id(options[:model])}_expand_area", :partial => "#{options[:model].class.contextless_name.downcase.pluralize}/list", :locals => { options[:model].class.contextless_name.downcase.to_sym => options[:model] })
    page.show("#{dom_id(options[:model])}_expand_area")
    page["#{dom_id(options[:model])}_heading_area"].addClassName("expanded")
    page["#{dom_id(options[:model])}_toggle_link"].setAttribute("onclick", remote_function(:url => { :action => :collapse, :id => options[:model].id }, :method => :get))
  end

  def collapse_root_element(page, options)
    page.hide("#{dom_id(options[:model])}_expand_area")
    page["#{dom_id(options[:model])}_toggle_link"].setAttribute("onclick", remote_function(:url => options[:url], :method => :get))
    page["#{dom_id(options[:model])}_heading_area"].removeClassName("expanded")
    page.replace_html("#{dom_id(options[:model])}_expand_area", "")
  end

end
