describe Platter::Cucumber::ImportService do

  describe "#import_file" do

    before(:all) do
      @feature = Platter::Cucumber::ImportService.import_file("#{RAILS_ROOT}/spec/resources/simple.feature")
    end

    it "should parse a Platter::Feature from a feature file" do
      @feature.should_not be_nil
      @feature.title.should eql("Some Simple Feature")
    end

    it "should parse Platter::FeatureLine's from a feature file" do
      @feature.lines.should have(3).elements

      ["As a developer",
       "I want to test feature importing",
       "So that I have confidence it works for real users"].each_with_index do |expected_line_text, i|
        @feature.lines[i].text.should eql(expected_line_text)
      end
    end

    it "should parse Platter:Scenario's from a feature file" do
      pending("Scenario conversion") do
        @feature.scenarios.should have(3).elements

        ["First Scenario", "Second Scenario", "Third Scenario"].each_with_index do |expected_scenario_title, i|
          @feature.scenarios[i].title.should eql(expected_scenario_title)
        end
      end
    end

    it "should parse Platter::Step's from a feature file" do
      pending("Step conversion") do
        %w(First Second Third).each_with_index do |scenario_category, scenario_counter|
          steps = @feature.scenarios[scenario_counter].steps
          steps.should have(3).elements
          [" scenario given", " scenario when", " scenario then"].each do |common_step_text, step_counter|
            steps[step_counter].text.should eql("#{scenario_category}#{common_step_text}")
          end
        end
      end
    end

  end

end
