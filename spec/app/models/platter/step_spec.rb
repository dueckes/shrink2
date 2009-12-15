module Platter
  describe Step do

    before(:each) do
      @step = Step.new(:text => "Some Text")
    end

    it "should have text" do
      @step.text.should eql("Some Text")
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

    it "should belong to a folder" do
      folder = Folder.new
      feature = Feature.new(:folder => folder)
      scenario = Scenario.new(:feature => feature)

      step = Step.new(:scenario => scenario)

      step.folder.should eql(folder)
    end

    it "should be a Platter::FeatureSummaryChangeObserver" do
      Step.include?(Platter::FeatureSummaryChangeObserver).should be_true
    end

    it "should be a Platter::Cucumber::Adapter::AstStepAdapter" do
      Step.include?(Platter::Cucumber::Adapter::AstStepAdapter).should be_true
    end

    it "should be a Platter::Cucumber::Formatter::TextFormatter" do
      Step.include?(Platter::Cucumber::Formatter::TextFormatter).should be_true
    end

    context "#valid?" do

      before(:each) do
        @step = Step.new
      end

      describe "when text has been provided" do

        describe "whose length is less than 256 characters" do

          before(:each) do
            @step.text = "a" * 255
          end

          it "should return true" do
            @step.should be_valid
          end

        end

        describe "whose length is 256 characters" do

          before(:each) do
            @step.text = "a" * 256
          end

          it "should return true" do
            @step.should be_valid
          end

        end

        describe "whose length is greater than 256 characters" do

          before(:each) do
            @step.text = "a" * 257
          end

          it "should return false" do
            @step.should_not be_valid
          end

        end

        describe "that is empty" do

          before(:each) do
            @step.text = ""
          end

          it "should return false" do
            @step.should_not be_valid
          end

        end

      end

      describe "when text has not been provided" do

        before(:each) do
          @step.text = nil
        end

        it "should return false" do
          @step.should_not be_valid
        end

      end

    end

    context "#calculate_summary" do

      it "should return the text" do
        @step.calculate_summary.should eql("Some Text")
      end

    end

  end
end