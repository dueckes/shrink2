module PackagesHelper

  def nested_dom_id(symbol, parent=nil)
    "#{dom_id(parent || @parent)}_#{symbol}"
  end

end
