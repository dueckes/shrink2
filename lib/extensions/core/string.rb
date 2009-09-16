String.class_eval do

  def as_directory_names
    self.split("/").collect { |name| name.gsub(/\//, "") } - [""]
  end

end
