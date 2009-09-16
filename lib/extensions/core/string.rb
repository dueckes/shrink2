String.class_eval do

  def as_directory_names
    directory_names = self.split("/")
    directory_names.empty? ? [self] : directory_names - [""]
  end

end
