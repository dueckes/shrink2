describe Shrink::Cucumber::Formatter::StepFormatter do

  class TestableStepFormatter
    include Shrink::Cucumber::Formatter::StepFormatter

    attr_accessor :text, :table

    def text_type?
      text != nil
    end

  end

  context "#to_cucumber_file_format" do

    before(:all) do
      @formatter = TestableStepFormatter.new
    end

    describe "when the formatter contains text" do

      before(:all) do
        @formatter.text = "Some Text"
      end

      it "should return the text" do
        @formatter.to_cucumber_file_format.should eql("Some Text")
      end

    end

    describe "when the formatter contains a table" do

      before(:all) do
        formatted_table = (1..3).collect { |i| "line #{i}" }.join("\n")
        @formatter.table = mock("Table", :to_cucumber_file_format => formatted_table)

        @lines = @formatter.to_cucumber_file_format.split("\n")
      end

      it "should contain the result of the table's to_cucumber_file_format" do
        @lines.each_with_index do |line, line_index|
          line.should match(/line #{line_index + 1}/)
        end
      end

      it "should prefix each line of the formatted table with two spaces for readability" do
        @lines.each { |line| line.should match(/^  line/) }
      end

    end

  end

end
