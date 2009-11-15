module PackagesHelper

  def expand_link(package)
    link_to_remote(package.name, { :url => package_path(package), :method => :get }, { :id => "#{dom_id(package)}_expand_link", :class => "list-title" })
  end

  def shrink_link(package)
    link_to_remote(package.name, { :url => { :action => :shrink, :id => package.id }, :method => :get }, { :id => "#{dom_id(@package)}_shrink_link", :class => "list-title"})
  end

  def nested_dom_id(symbol, parent=nil)
    "#{dom_id(parent || @parent)}_#{symbol}"
  end

end
