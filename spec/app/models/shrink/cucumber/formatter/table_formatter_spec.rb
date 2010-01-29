describe Shrink::Cucumber::Formatter::TableFormatter  do

  class TestableTableFormatter
    include Shrink::Cucumber::Formatter::TableFormatter

    attr_reader :rows_with_padded_cell_text

    def initialize(rows_with_padded_cell_text)
      @rows_with_padded_cell_text = rows_with_padded_cell_text
    end

  end

  context "#to_cucumber_file_format" do

    describe "when the formatter has a table" do
      
      describe "containing a single cell" do

        before(:all) do
          @formatter = TestableTableFormatter.new([["Row 1 Column 1"]])

          @result = @formatter.to_cucumber_file_format
        end

        it "should start the formatted text with a pipe symbol and a space" do
          @result.should match(/^\| /)
        end

        it "should end the formatted text with a space and a pipe symbol" do
          @result.should match(/ \|$/)
        end

        it "should place the text between the surrounding formatting characters" do
          remove_surrounding_formatting_from(@result).should eql("Row 1 Column 1")
        end

      end

      describe "containing multiple rows and multiple columns" do

        before(:all) do
          @rows_with_padded_cell_text = (1..3).collect do |row_number|
            (1..3).collect do |column_number|
              "Row #{row_number} Column #{column_number}"
            end
          end
          @formatter = TestableTableFormatter.new(@rows_with_padded_cell_text)

          @result = @formatter.to_cucumber_file_format
          @lines = @result.split("\n")
        end

        it "should preserve the order of the rows, starting each row on a separate line" do
          @lines.each_with_index { |line, row_index| line.should match(/Row #{row_index + 1}/) }
        end

        it "should create lines starting with a pipe symbol and a space" do
          @lines.each { |line| line.should match(/^\| /) }
        end

        it "should create lines ending with a space and a pipe symbol" do
          @lines.each { |line| line.should match(/ \|$/) }
        end

        it "should divide each cell with a pipe symbol and a space before and after" do
          @lines.each_with_index do |line, row_index|
            expected_cell_texts = (1..3).collect { |column_position| "Row #{row_index + 1} Column #{column_position}" }
            remove_surrounding_formatting_from(line).split(" | ").should eql(expected_cell_texts)
          end
        end

      end

    end

    def remove_surrounding_formatting_from(line)
      line.gsub(/^[^a-z0-9]*/i, "").gsub(/[^a-z0-9]\|$/i, "")
    end

  end

end
