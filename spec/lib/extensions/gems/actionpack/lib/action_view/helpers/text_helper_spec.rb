describe Shrink::ActionView::Helpers::TextHelper do

  class TestableTextHelper

    def simple_format(text, html_options={})
      "original format #{text}"
    end

    def textilize(text, *options)
      "textilized #{text}"
    end

    include Shrink::ActionView::Helpers::TextHelper
  end

  before(:all) do
    @testable_text_helper = TestableTextHelper.new
  end

  context "#simple_format" do

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

  context "#textilize" do

    describe "when the text does not contain table markup" do

      before(:all) do
        @text = "text"
      end

      it "should invoke the original method with the same text" do
        invoke_textilize_and_expect_adjusted_text(@text, @text)
      end

    end

    describe "when the text does contain table markup" do

      before(:all) do
        @table_markup = "|header 1|header 2|header 3|\n|value 1|value 2|value 3|"
      end

      describe "that is preceded by no line feeds" do

        before(:all) do
          @text = @table_markup
        end

        it "should return invoke the original method with the text unaltered" do
          invoke_textilize_and_expect_adjusted_text(@text, @table_markup)
        end

      end

      describe "that is preceded by one line feed" do

        before(:all) do
          @text = "\n#{@table_markup}"
        end

        it "should invoke the original method with no line feeds preceding the text" do
          invoke_textilize_and_expect_adjusted_text(@text, @table_markup)
        end

      end

      describe "that is preceded by lines of text" do

        before(:all) do
          @text = "Some\nText\n#{@table_markup}"
        end

        it "should invoke the original method with the lines of text and the table markup preceded by two line feeds" do
          invoke_textilize_and_expect_adjusted_text(@text, "Some\nText\n\n#{@table_markup}")
        end

      end

      describe "that is preceded by two line feeds" do

        before(:all) do
          @text = "\n\n#{@table_markup}"
        end

        it "should invoke the original method with no line feeds preceding the text" do
          invoke_textilize_and_expect_adjusted_text(@text, @table_markup)
        end

      end

      describe "that is proceeded by another markup for another table preceded by two line feeds" do

        before(:all) do
          @text = "#{@table_markup}\n\n#{@table_markup}"
        end

        it "should invoke the original method with text that preserves the two line feeds before the second table" do
          invoke_textilize_and_expect_adjusted_text(@text, @text)
        end

      end

    end

    def invoke_textilize_and_expect_adjusted_text (text, expected_original_text)
      @testable_text_helper.should_receive(
              :textilize_without_table_whitespace_support).with(expected_original_text).and_return("html")

      @testable_text_helper.textilize(text).should eql("html")
    end

  end

end
