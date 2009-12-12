module AddAnywhereHelper

  def add_before_link(options)
    add_anywhere_link("+", :show_before_id => dom_id(options[:model]),
                      :id => dom_id(options[:model], :add_link), :url => options[:url], :title => "Add Before")
  end

  def add_at_end_link(options)
    add_anywhere_link("Add #{options[:model_name].to_s.humanize.titleize}",
                      :id => dom_id(options[:parent], "add_#{options[:model_name]}_end_link"),
                      :url => options[:url], :title => "Add Here")
  end

  private
  def add_anywhere_link(name, options)
    link_id = options[:id]
    link_js_object = "$('##{link_id}')"
    link_to_remote name, { :url => options[:url], :method => :get,
                           :with => "'clicked_item_dom_id=' + #{link_js_object}.closest('li').attr('id')" },
                   { :id => link_id, :title => options[:title] }
  end

end
