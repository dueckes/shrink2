describe Platter::Cucumber::Formatter::FeatureFormatter do

  class TestableFeatureFormatter
    include Platter::Cucumber::Formatter::FeatureFormatter
    attr_accessor :title
    attr_accessor :tags
    attr_accessor :lines
    attr_accessor :scenarios
  end

  context "#to_cucumber_file_format" do

    before(:each) do
      @testable_feature_formatter = TestableFeatureFormatter.new
      @testable_feature_formatter.title = "Some Feature Title"
      @testable_feature_formatter.tags = @tags =
              (1..3).collect { |i| mock("Tag#{i}", :to_cucumber_file_format => "tag_#{i}") }
      @testable_feature_formatter.lines = @lines =
              (1..3).collect { |i| mock("FeatureLine#{i}", :to_cucumber_file_format => "feature line #{i}") }
      @testable_feature_formatter.scenarios = @scenarios =
              (1..3).collect { |i| mock("Scenario#{i}", :to_cucumber_file_format => "scenario #{i}") }

      @formatted_lines = @testable_feature_formatter.to_cucumber_file_format.split("\n")
    end

    describe "the tags" do

      it "should be on the first formatted line with their formatted output space delimited" do
        @formatted_lines.first.should eql("tag_1 tag_2 tag_3")
      end

    end

    describe "the feature title" do

      it "should be on the second formatted line prefixed by 'Feature: '" do
        @formatted_lines.second.should include("Some Feature Title")
      end

    end

    describe "the lines" do

      it "should occupy the formatted lines directly after the feature title and have their formatted output prefixed by spaces for readability" do
        @formatted_lines[2..4].should eql(["  feature line 1", "  feature line 2", "  feature line 3"])
      end

    end

    describe "the scenarios" do

      it "should occupy the formatted lines directly after the feature lines and should each be prefixed by an empty line for readability" do
        @formatted_lines[5..10].should eql(["", "scenario 1", "", "scenario 2", "", "scenario 3"])
      end

    end

  end

end
