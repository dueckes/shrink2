describe Platter::Cucumber::Formatter::ScenarioFormatter do

  class TestableScenarioFormatter
    include Platter::Cucumber::Formatter::ScenarioFormatter
    attr_accessor :title
    attr_accessor :steps
  end

  before(:each) do
    @scenario_formatter = TestableScenarioFormatter.new
    @scenario_formatter.title = "Some Title"
    @scenario_formatter.steps = (1..3).collect { |i| mock("Step#{i}", :to_cucumber_file_format => "formatted step #{i}") }
  end

  context "#to_cucumber_file_format" do

    before(:each) do
      @formatted_lines = @scenario_formatter.to_cucumber_file_format.split("\n")
    end

    describe "the scenario title" do

      it "should be on the first formatted line prefixed by 'Scenario: '" do
        @formatted_lines.first.should eql("Scenario: Some Title")
      end

    end

    describe "the steps" do

      it "should be on the following formatted lines prefixed by spaces for readability" do
        @formatted_lines[1..3].should eql(["  formatted step 1", "  formatted step 2", "  formatted step 3"])
      end

    end

  end

end
