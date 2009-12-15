String.class_eval do

  def as_folder_names
    self.split("/").collect { |name| name.gsub(/\//, "") } - [""]
  end

  def fileize
    self.downcase.gsub(/\s/, "_").gsub(/\W/, "")
  end

end
