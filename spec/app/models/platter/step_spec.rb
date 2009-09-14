describe Platter::Step do

  it "should have text" do
    step = Platter::Step.new(:text => "Some Text")

    step.text.should eql("Some Text")
  end

  it "should belong to a scenario" do
    scenario = Platter::Scenario.new

    step = Platter::Step.new(:scenario => scenario)

    step.scenario.should eql(scenario)
  end

  it "should belong to a feature" do
    feature = Platter::Feature.new
    scenario = Platter::Scenario.new(:feature => feature)

    step = Platter::Step.new(:scenario => scenario)

    step.feature.should eql(feature)
  end

  it "should belong to a package" do
    package = Platter::Package.new
    feature = Platter::Feature.new(:package => package)
    scenario = Platter::Scenario.new(:feature => feature)

    step = Platter::Step.new(:scenario => scenario)

    step.package.should eql(package)
  end

  describe "#valid?" do

    describe "when text has been provided" do

      before(:each) do
        @step = Platter::Step.new(:text => "Some Text")
      end

      it "should return true" do
        @step.should be_valid

      end

    end

    describe "when no text has been provided" do

      before(:each) do
        @step = Platter::Step.new
      end

      it "should return false" do
        @step.should_not be_valid
      end

    end

  end

end
