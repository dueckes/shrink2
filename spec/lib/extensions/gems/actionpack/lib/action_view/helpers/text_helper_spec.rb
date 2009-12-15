describe Platter::ActionView::Helpers::TextHelper do

  class TestableTextHelper

    def simple_format(text, html_options={})
      "original format #{text}"
    end

    include Platter::ActionView::Helpers::TextHelper
  end


  context "#simple_format" do

    before(:each) do
      @testable_text_helper = TestableTextHelper.new
    end

    describe "when the text contains spaces" do

      it "should convert the spaces to '&nbsp;' and invoke the original method" do
        @testable_text_helper.simple_format(" some text ").should eql("original format &nbsp;some&nbsp;text&nbsp;")
      end

    end

    describe "when the text does not contain spaces" do

      it "should invoke the original method" do
        @testable_text_helper.simple_format("text").should eql("original format text")
      end

    end

  end

end
