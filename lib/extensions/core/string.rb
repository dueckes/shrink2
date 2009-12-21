String.class_eval do

  def as_folder_names
    self.split("/").collect { |name| name.gsub(/\//, "") } - [""]
  end

  def fileize
    self.strip.gsub(/[^a-z0-9_\-\s]/i, "")
  end

  def contains_complete_word?
    !!self.match(/^[^\s]+\s/)
  end

end
