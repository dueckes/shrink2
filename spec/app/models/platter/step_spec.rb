module Platter
  describe Step do

    it "should have text" do
      step = Step.new(:text => "Some Text")

      step.text.should eql("Some Text")
    end

    it "should belong to a scenario" do
      scenario = Scenario.new

      step = Step.new(:scenario => scenario)

      step.scenario.should eql(scenario)
    end

    it "should belong to a feature" do
      feature = Feature.new
      scenario = Scenario.new(:feature => feature)

      step = Step.new(:scenario => scenario)

      step.feature.should eql(feature)
    end

    it "should belong to a package" do
      package = Package.new
      feature = Feature.new(:package => package)
      scenario = Scenario.new(:feature => feature)

      step = Step.new(:scenario => scenario)

      step.package.should eql(package)
    end

    describe "#valid?" do

      describe "when text has been provided" do

        before(:each) do
          @step = Step.new(:text => "Some Text")
        end

        it "should return true" do
          @step.should be_valid

        end

      end

      describe "when no text has been provided" do

        before(:each) do
          @step = Step.new
        end

        it "should return false" do
          @step.should_not be_valid
        end

      end

    end

    describe '#as_text' do
      it 'should return the text' do
        text = 'this is a feature step'
        Step.new(:text => text).as_text.should eql text
      end
    end

  end
end