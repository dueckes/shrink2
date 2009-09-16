describe Platter::Cucumber::FeatureImporter do

  context "#import_file" do

    describe "integrating with real converters and the file system" do

      describe "when the directory has one feature file" do

        before(:all) do
          @feature = Platter::Cucumber::FeatureImporter.import_file("#{RAILS_ROOT}/spec/resources/simple.feature")
        end

        it "should parse a Platter::Feature from the feature file" do
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
          @feature.scenarios.should have(3).elements

          ["First Scenario", "Second Scenario", "Third Scenario"].each_with_index do |expected_scenario_title, i|
            @feature.scenarios[i].title.should eql(expected_scenario_title)
          end
        end

        it "should parse Platter::Step's from a feature file" do
          %w(First Second Third).each_with_index do |scenario_category, scenario_counter|
            expected_step_text = %w(Given And When Then).collect do |step_keyword|
              "#{step_keyword} #{scenario_category} scenario #{step_keyword.downcase}"
            end
            steps = @feature.scenarios[scenario_counter].steps
            steps.collect(&:text).should eql(expected_step_text)
          end
        end

      end

    end

  end

end
