describe Shrink::Cucumber::Formatter::FeatureFormatter do

  class TestableFeatureFormatter
    include Shrink::Cucumber::Formatter::FeatureFormatter
    attr_accessor :title
    attr_accessor :tags
    attr_accessor :description_lines
    attr_accessor :scenarios
  end

  context "#to_cucumber_file_format" do

    before(:each) do
      @testable_feature_formatter = TestableFeatureFormatter.new
      @testable_feature_formatter.title = "Some Feature Title"
      @testable_feature_formatter.tags = @tags =
              (1..3).collect { |i| mock("Tag#{i}", :to_cucumber_file_format => "tag_#{i}") }
      @testable_feature_formatter.description_lines = @description_lines =
              (1..3).collect { |i| mock("FeatureDescriptionLine#{i}", :to_cucumber_file_format => "Description Line #{i}") }
      @testable_feature_formatter.scenarios = @scenarios =
              (1..3).collect { |i| mock("Scenario#{i}", :to_cucumber_file_format => "Scenario #{i}") }

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

    describe "the description lines" do

      it "should occupy the formatted lines directly after the feature title and have their formatted output prefixed by spaces for readability" do
        @formatted_lines[2..4].should eql(["  Description Line 1", "  Description Line 2", "  Description Line 3"])
      end

    end

    describe "the scenarios" do

      it "should occupy the formatted lines directly after the description lines and should each be prefixed by an empty line for readability" do
        @formatted_lines[5..10].should eql(["", "Scenario 1", "", "Scenario 2", "", "Scenario 3"])
      end

    end

  end

end
