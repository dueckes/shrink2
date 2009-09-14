class DatabaseModelFixture

  def self.create_package!(options={})
    default_options = { :name => "Package Name" }
    combined_options = default_options.merge(options)
    Platter::Package.create!(combined_options)
  end

  def self.create_feature!
    Platter::Feature.create!(:package => create_package!, :title => "Feature Title")
  end

  def self.create_scenario!
    Platter::Scenario.create!(:feature => create_feature!, :title => "Scenario Title")
  end

end
