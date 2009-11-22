class DatabaseModelFixture

  def self.create_package!(options={})
    default_options = { :name => "Package Name" }
    combined_options = default_options.merge(options)
    Platter::Package.create!(combined_options)
  end

  def self.find_or_create_package!(options={})
    Platter::Package.find(:first) || create_package!(options)
  end

  def self.create_feature!(options={})
    combined_options = { :title => "Feature Title" }.merge(options)
    combined_options[:package] = find_or_create_package! unless combined_options[:package]
    Platter::Feature.create!(combined_options)
  end

  def self.find_or_create_feature!(options={})
    Platter::Feature.find(:first) || create_feature!(options)
  end

  def self.create_scenario!
    Platter::Scenario.create!(:feature => find_or_create_feature!, :title => "Scenario Title")
  end

end
