describe Platter::Cucumber::Formatter::TextFormatter do

  class TestableTextFormatter
    include Platter::Cucumber::Formatter::TextFormatter
    attr_accessor :text
  end

  before(:each) do
    @text_formatter = TestableTextFormatter.new
    @text_formatter.text = "Some Text"
  end

  context "#to_cucumber_file_format" do

    it "should return the text of the objects in which it is included" do
      @text_formatter.to_cucumber_file_format.should eql("Some Text")
    end

  end

end
