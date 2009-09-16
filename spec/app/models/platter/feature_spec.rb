describe Platter::Feature do

  it "should belong to a package" do
    package = Platter::Package.new(:name => "Some package")

    feature = Platter::Feature.new(:package => package)

    feature.package.should eql(package)
  end

  it "should have a title" do
    feature = Platter::Feature.new(:title => "Some Title")

    feature.title.should eql("Some Title")
  end

  it "should have feature lines" do
    feature = Platter::Feature.new

    lines = (1..3).collect do |i|
      line = create_mock_line(:text => "Line#{i}")
      feature.lines << line
      line
    end

    feature.lines.should eql(lines)
  end

  it "should have scenarios" do
    feature = Platter::Feature.new

    scenarios = (1..3).collect do |i|
      scenario = create_mock_scenario(:title => "Scenario#{i}")
      feature.scenarios << scenario
      scenario
    end

    feature.scenarios.should eql(scenarios)
  end

  it "should be a Platter::Cucumber::Ast::FeatureConverter" do
    Platter::Feature.include?(Platter::Cucumber::Ast::FeatureConverter).should be_true
  end

  context "#valid?" do

    before(:each) do
      @feature = Platter::Feature.new(:package => Platter::Package.new(:name => "Some package"), :title => "Some Title")
    end

    describe "when a title is established" do

      it "should return true" do
        @feature.should be_valid
      end

    end

    describe "when no title is established" do

      before(:each) do
        @feature.title = nil
      end

      it "should return false" do
        @feature.should_not be_valid
      end

    end

    describe "when a package is established" do

      it "should return true" do
        @feature.should be_valid
      end

    end

    describe "when no package is established" do

      before(:each) do
        @feature.package = nil
      end

      it "should return false" do
        @feature.should_not be_valid
      end

    end

  end

  def create_mock_line(stubs)
    StubModelFixture.create_model(Platter::FeatureLine, stubs)
  end

  def create_mock_scenario(stubs)
    StubModelFixture.create_model(Platter::Scenario, stubs)
  end

end
