describe Shrink::Cucumber::Formatter::TagFormatter do

  class TestableTagFormatter
    include Shrink::Cucumber::Formatter::TagFormatter
    attr_accessor :name
  end

  before(:each) do
    @tag_formatter = TestableTagFormatter.new
  end

  context "#to_cucumber_file_format" do

    describe "when the formatter has a tag name containing no spaces" do

      before(:each) do
        @tag_formatter.name = "name_without_spaces"
      end

      it "should return the tag name prefixed with an at symbol" do
        @tag_formatter.to_cucumber_file_format.should eql("@name_without_spaces")
      end

    end

    describe "when the formatter has a tag name containing spaces" do

      before(:each) do
        @tag_formatter.name = "name with spaces"
      end

      it "should return the tag name with spaces replaced by underscores and prefixed with an at symbol" do
        @tag_formatter.to_cucumber_file_format.should eql("@name_with_spaces")
      end

    end

    describe "when the formatter has a tag name with upper case characters" do

      before(:each) do
        @tag_formatter.name = "Upper Case Name"
      end

      it "should return the tag name with no change in character casing and prefixed with an at symbol" do
        @tag_formatter.to_cucumber_file_format.should eql("@Upper_Case_Name")
      end

    end

  end

end
