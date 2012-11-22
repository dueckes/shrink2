module AddAnywhereHelper

  def add_before_link(options)
    combined_options = { :name => icon(:plus), :title => "Add Before", :id_prefix => :add_link }.merge(options)
    add_anywhere_link(combined_options[:name], :show_before_id => dom_id(options[:model]),
                      :id => dom_id(options[:model], options[:id_prefix]),
                      :url => options[:url], :title => combined_options[:title])
  end

  def add_at_end_link(options)
    combined_options = { :name => "Add #{options[:model_name].to_s.humanize.downcase}",
                         :id_prefix => "add_#{options[:model_name]}_end_link", :title => "Add Here" }.merge(options)
    add_anywhere_link(combined_options[:name], :id => dom_id(options[:parent], combined_options[:id_prefix]),
                      :url => options[:url], :title => combined_options[:title])
  end

  private
  def add_anywhere_link(name, options)
    link_to name, "#", :remote => true, :method => :get, "data-url" => url_for(options[:url]),
                       :id => options[:id], :class => :add_anywhere_link, :title => options[:title]
  end

end
