module RootElementHelper

  def show_root_element(page, options)
    page.replace_html("#{dom_id(options[:model])}_expand_area", :partial => "#{options[:model].class.contextless_name.downcase.pluralize}/show_expanded", :locals => { options[:model].class.contextless_name.downcase.to_sym => options[:model] })
    page.show("#{dom_id(options[:model])}_expand_area")
    page["#{dom_id(options[:model])}_details"].addClassName("expanded")
    page["#{dom_id(options[:model])}_toggle_link"].setAttribute("onclick", remote_function(:url => { :action => :shrink, :id => options[:model].id }, :method => :get))
  end

  def shrink_root_element(page, options)
    page.hide("#{dom_id(options[:model])}_expand_area")
    page["#{dom_id(options[:model])}_toggle_link"].setAttribute("onclick", remote_function(:url => options[:url], :method => :get))
    page["#{dom_id(options[:model])}_details"].removeClassName("expanded")
    page.replace_html("#{dom_id(options[:model])}_expand_area", "")
  end

end
