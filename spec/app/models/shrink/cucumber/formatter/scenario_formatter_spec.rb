describe Shrink::Cucumber::Formatter::ScenarioFormatter do

  class TestableScenarioFormatter
    include Shrink::Cucumber::Formatter::ScenarioFormatter
    attr_accessor :title, :steps
  end

  before(:each) do
    @scenario_formatter = TestableScenarioFormatter.new
    @scenario_formatter.title = "Some Title"
    @scenario_formatter.steps = (1..3).collect { |i| mock("Step#{i}", :to_cucumber_file_format =>
            (1..3).collect { |j| "formatted step #{i}.#{j}" }.join("\n")) }
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

      it "should be on the following formatted lines and have each of their lines prefixed by spaces for readability" do
        expected_step_lines = (1..3).collect do |i|
          (1..3).collect { |j| "  formatted step #{i}.#{j}" }
        end.flatten
        @formatted_lines[1..9].should eql(expected_step_lines)
      end

    end

  end

end
