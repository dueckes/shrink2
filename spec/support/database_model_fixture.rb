class DatabaseModelFixture

  def self.create_folder!(options={})
    default_options = { :name => "Folder Name" }
    combined_options = default_options.merge(options)
    Platter::Folder.create!(combined_options)
  end

  def self.find_or_create_folder!(options={})
    Platter::Folder.find(:first) || create_folder!(options)
  end

  def self.create_tag!(options={})
    default_options = { :name => "Tag Name" }
    combined_options = default_options.merge(options)
    Platter::Tag.create!(combined_options)
  end

  def self.create_feature!(options={})
    combined_options = { :title => "Feature Title" }.merge(options)
    combined_options[:folder] = find_or_create_folder! unless combined_options[:folder]
    Platter::Feature.create!(combined_options)
  end

  def self.find_or_create_feature!(options={})
    Platter::Feature.find(:first) || create_feature!(options)
  end

  def self.create_scenario!
    Platter::Scenario.create!(:feature => find_or_create_feature!, :title => "Scenario Title")
  end

end
