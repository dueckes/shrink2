Module.class_eval do

  def contextless_name
    name.match(/[^:]*$/)[0]
  end

end
