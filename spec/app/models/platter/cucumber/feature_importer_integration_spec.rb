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

  context "#import_directory" do

    describe "when a directory contains many feature files" do

      before(:all) do
        @features = Platter::Cucumber::FeatureImporter.import_directory(
                "#{RAILS_ROOT}/spec/resources/parent_feature_directory/child_feature_directory")
      end

      it "should create a feature for each feature file" do
        @features.collect(&:title).should eql(["First Feature", "Second Feature", "Third Feature"])
      end

      it "should create features whose package is the root package" do
        root_package = Platter::Package.root

        @features.each { |feature| feature.package.should eql(root_package)}
      end

    end

    describe "when a directory contains many feature files within a sub-directory" do

      before(:all) do
        @features = Platter::Cucumber::FeatureImporter.import_directory(
                "#{RAILS_ROOT}/spec/resources/parent_feature_directory")
      end

      it "should create a feature for each feature file" do
        @features.collect(&:title).should eql(["First Feature", "Second Feature", "Third Feature"])
      end

      it "should create features whose package has a name matching the sub-directory name" do
        @features.each { |feature| feature.package.name.should eql("child_feature_directory") }
      end

      it "should create features who share the same package" do
        @features.collect(&:package_id).uniq.size.should eql(1)
      end

      it "should create features whose package has a parent package that is the root package" do
        root_package = Platter::Package.root

        @features.each { |feature| feature.package.parent.should eql(root_package)}
      end

    end

  end

end
