module Platter
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

    it "should belong to a package" do
      package = Package.new
      feature = Feature.new(:package => package)

      scenario = Scenario.new(:feature => feature)

      scenario.package.should eql(package)
    end

    it "should be a Platter::Cucumber::Ast::ScenarioConverter" do
      Platter::Scenario.include?(Platter::Cucumber::Ast::ScenarioConverter).should be_true
    end

    context "#valid?" do

      before(:each) do
        @scenario = Scenario.new(:feature => Feature.new, :title => "Some Title")
        @scenario.steps << create_step(:scenario => @scenario, :text => "Some Step")
      end

      describe "when a feature has been provided" do

        describe "and a title has been provided" do

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

            it "should return false" do
              @scenario.should_not be_valid
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
              @scenario.steps << Platter::Step.new(:text => "")
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

      describe "when a feature has not been provided" do

        before(:each) do
          @scenario.feature = nil
        end

        it "should return false" do
           @scenario.should_not be_valid
        end

      end

    end

    context "#as_text" do

      it "should include the scenario tile" do
        title = "scenario title"
        scenario = Scenario.new(:title => title)
        scenario.as_text.should include "Scenario: #{title}"
      end

      it "should indent & include the as text for its child steps" do
        scenario = Scenario.new(:title => "some title")
        scenario.steps << Step.new(:text => "step one text") << Step.new(:text => "step two text")

        text = scenario.as_text
        text.should include("  step one text")
        text.should include("  step two text")
      end

    end

    def create_step(attributes)
      Step.new(attributes)
    end

  end
end