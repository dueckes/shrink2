module PackagesHelper

  def expand_link(package)
    link_to_remote("Expand", { :url => package_path(package), :method => :get }, { :id => "#{dom_id(package)}_expand_link" })
  end

  def nested_dom_id(symbol, parent=nil)
    "#{dom_id(parent || @parent)}_#{symbol}"
  end

end
