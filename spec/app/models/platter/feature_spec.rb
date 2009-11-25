module Platter
  describe Feature do

    it "should belong to a package" do
      package = Package.new(:name => "Some package")

      feature = Feature.new(:package => package)

      feature.package.should eql(package)
    end

    it "should have a title" do
      feature = Feature.new(:title => "Some Title")

      feature.title.should eql("Some Title")
    end

    it "should have tags" do
      feature = Feature.new

      tags = (1..3).collect do |i|
        tag = create_mock_tag(:name => "Tag#{i}")
        feature.tags << tag
        tag
      end

      feature.tags.should eql(tags)
    end

    it "should have feature lines" do
      feature = Feature.new

      lines = (1..3).collect do |i|
        line = create_mock_line(:text => "Line#{i}")
        feature.lines << line
        line
      end

      feature.lines.should eql(lines)
    end

    it "should have scenarios" do
      feature = Feature.new

      scenarios = (1..3).collect do |i|
        scenario = create_mock_scenario(:title => "Scenario#{i}")
        feature.scenarios << scenario
        scenario
      end

      feature.scenarios.should eql(scenarios)
    end

    it "should be a Platter::Cucumber::Ast::FeatureConverter" do
      Platter::Feature.include?(Platter::Cucumber::Ast::FeatureConverter).should be_true
    end

    context "#valid?" do

      before(:each) do
        @feature = Feature.new(:package => Package.new(:name => "Some package"), :title => "Some Title")
      end

      describe "when a package has been provided" do

        describe "and a title has been provided" do

          describe "whose length is less than 256 characters" do

            before(:each) do
              @feature.title = "a" * 255
            end

            it "should return true" do
              @feature.should be_valid
            end

          end

          describe "whose length is 256 characters" do

            before(:each) do
              @feature.title = "a" * 256
            end

            it "should return false" do
              @feature.should_not be_valid
            end

          end

          describe "whose length is greater than 256 characters" do

            before(:each) do
              @feature.title = "a" * 257
            end

            it "should return false" do
              @feature.should_not be_valid
            end

          end

          describe "that is empty" do

            before(:each) do
              @feature.title = ""
            end

            it "should return false" do
              @feature.should_not be_valid
            end

          end

        end

        describe "and a title has not been provided" do

          before(:each) do
            @feature.title = nil
          end

          it "should return false" do
            @feature.should_not be_valid
          end

        end

      end

      describe "when a package has not been provided" do

        before(:each) do
          @feature.package = nil
        end

        it "should return false" do
          @feature.should_not be_valid
        end

      end

      describe "when an invalid line has been added" do

        before(:each) do
          @feature.lines << Platter::FeatureLine.new(:text => "")
        end

        it "should return false" do
          @feature.should_not be_valid
        end

      end

      describe "when an invalid scenario has been added" do

        before(:each) do
          @feature.scenarios << Platter::Scenario.new(:title => "")
        end

        it "should return false" do
          @feature.should_not be_valid
        end

      end

    end

    context "#as_text" do

      it "should include the feature title" do
        title = "this is a feature title"
        Feature.new(:title => title).as_text.should include "Feature: #{title}"
      end

      it "should indent & include feature lines" do
        feature = Feature.new
        feature.lines << StubModelFixture.create_model(FeatureLine, :as_text => "first feature line")
        feature.lines << StubModelFixture.create_model(FeatureLine, :as_text => "second feature line")
        text = feature.as_text
        text.should include "  first feature line"
        text.should include "  second feature line"
      end

      it "should include scenarios" do
        feature = Feature.new
        feature.scenarios << StubModelFixture.create_model(Scenario, :as_text => "first scenario")
        feature.scenarios << StubModelFixture.create_model(Scenario, :as_text => "second scenario")
        text = feature.as_text
        text.should include "first scenario"
        text.should include "second scenario"
      end

    end

    context "#export_name"  do

      it "should use the title" do
        title = "some_title"
        Feature.new(:title => title).export_name.should eql title
      end

      it "should replace spaces with underscores" do
        Feature.new(:title => "title with spaces").export_name.should eql "title_with_spaces"
      end

      it "should downcase the title" do
        Feature.new(:title => "Title WITH MIXED cAse").export_name.should eql "title_with_mixed_case"
      end

      it "should drop all non alpha numeric characters" do
        Feature.new(:title => 'T1tle !@#$%with n0n alph4 numeric +)(*&^characters and numb3rs').export_name.should eql "t1tle_with_n0n_alph4_numeric_characters_and_numb3rs"
      end

    end
    
    def create_mock_tag(stubs)
      StubModelFixture.create_model(Tag, stubs)
    end

    def create_mock_line(stubs)
      StubModelFixture.create_model(FeatureLine, stubs)
    end

    def create_mock_scenario(stubs)
      StubModelFixture.create_model(Scenario, stubs)
    end

  end
end