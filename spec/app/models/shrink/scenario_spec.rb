module Shrink
  describe Scenario do

    it "should have a title" do
      scenario = Scenario.new(:title => "Some Title")

      scenario.title.should eql("Some Title")
    end

    it "should have steps" do
      scenario = Scenario.new
      steps = (1..3).collect do |i|
        step = create_step(:text => "Step#{i}")
        scenario.steps << step
        step
      end

      scenario.steps.should eql(steps)
    end

    it "should belong to a feature" do
      feature = Feature.new

      scenario = Scenario.new(:feature => feature)

      scenario.feature.should eql(feature)
    end

    it "should belong to a folder" do
      folder = Folder.new
      feature = Feature.new(:folder => folder)

      scenario = Scenario.new(:feature => feature)

      scenario.folder.should eql(folder)
    end

    it "should be a Shrink::FeatureSummaryChangeObserver" do
      Scenario.include?(Shrink::FeatureSummaryChangeObserver).should be_true
    end

    it "should be a Shrink::Cucumber::Adapter::AstScenarioAdapter" do
      Scenario.include?(Shrink::Cucumber::Adapter::AstScenarioAdapter).should be_true
    end

    it "should be a Shrink::Cucumber::Formatter::ScenarioFormatter" do
      Scenario.include?(Shrink::Cucumber::Formatter::ScenarioFormatter).should be_true
    end

    context "#valid?" do

      before(:each) do
        @scenario = Scenario.new(:title => "Some Title")
        @scenario.steps << create_step(:scenario => @scenario, :text => "Some Step")
      end

      describe "when a title has been provided" do

        describe "whose length is less than 256 characters" do

          before(:each) do
            @scenario.title = "a" * 255
          end

          it "should return true" do
            @scenario.should be_valid
          end

        end

        describe "whose length is 256 characters" do

          before(:each) do
            @scenario.title = "a" * 256
          end

          it "should return true" do
            @scenario.should be_valid
          end

        end

        describe "whose length is greater than 256 characters" do

          before(:each) do
            @scenario.title = "a" * 257
          end

          it "should return false" do
            @scenario.should_not be_valid
          end

        end

        describe "that is empty" do

          before(:each) do
            @scenario.title = ""
          end

          it "should return false" do
            @scenario.should_not be_valid
          end

        end

        describe "and no steps have been added" do

          before(:each) do
            @scenario.steps.clear
          end

          it "should return true" do
            @scenario.should be_valid
          end

        end

        describe "and one step has been added" do

          it "should return true" do
            @scenario.should be_valid
          end

        end

        describe "and many steps have been added" do

          before(:each) do
            (1..3).collect { |i| @scenario.steps << create_step(:scenario => @scenario, :text => "Step#{i}") }
          end

          it "should return true" do
            @scenario.should be_valid
          end

        end

        describe "and an invalid step has been added" do

          before(:each) do
            @scenario.steps << Shrink::Step.new(:text => "")
          end

          it "should return false" do
            @scenario.should_not be_valid
          end

        end

      end

      describe "and a title has not been provided" do

        before(:each) do
          @scenario.title = nil
        end

        it "should return false" do
          @scenario.should_not be_valid
        end

      end

    end

    context "#calculate_summary" do

      describe "when the scenario is fully populated" do

        before(:all) do
          @scenario = Scenario.new(:title => "Some Title")
          @steps = (1..3).collect do |i|
            mock("Step#{i}", :calculate_summary => "step summary #{i}", :text_type? => i % 2 > 0)
          end
          @scenario.stub!(:steps).and_return(@steps)

          @summary_lines = @scenario.calculate_summary.split("\n")
        end

        describe "the scenario title" do

          it "should be on the first line" do
            @summary_lines.first.should eql("Some Title")
          end

        end

        describe "the steps" do

          it "should be summarized on the following lines" do
            (@summary_lines[1..-1] - [""]).should eql(["step summary 1", "step summary 2", "step summary 3"])
          end

          describe "that are type table" do

            it "should be preceded by an empty line for textile layout purposes" do
              @summary_lines[2..3].should eql(["", "step summary 2"])
            end

          end

          describe "that are type text" do

            it "should not be preceded by empty line" do
              @summary_lines.values_at(1, 4).should eql(["step summary 1", "step summary 3"])
            end

          end

        end

        it "should not modify the title" do
          @scenario.title.should eql("Some Title")
        end

      end

    end

    def create_step(attributes)
      Step.new(attributes)
    end

  end
end