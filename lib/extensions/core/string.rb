String.class_eval do

  def as_folder_names
    self.split("/").collect { |name| name.gsub(/\//, "") } - [""]
  end

end
