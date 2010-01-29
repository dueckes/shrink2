describe Shrink::Cucumber::Adapter::AstTableAdapter do

  class TestableAstTableAdapter
    include Shrink::Cucumber::Adapter::AstTableAdapter
  end

  context "#adapt" do

    before(:all) do
      @adapter = TestableAstTableAdapter
    end

    describe "when the Cucumber table contains a single row" do

      describe "containing one cell" do

        before(:all) do
          to_table([["cell text"]])
        end

        it "should create a Shrink::Table" do
          @table.should_not be_nil

        end

        it "should create a table with one Shrink::Row" do
          @table.rows.should have(1).row
        end

        it "should create a row with one Shrink::Cell" do
          @table.rows.first.cells.should have(1).cell
        end

        it "should create a cell with the text in the Cucumber cell" do
          @table.rows.first.cells.first.text.should eql("cell text")
        end

      end

      describe "containing multiple cells" do

        before(:all) do
          @row_cell_texts = ["cell 1", "cell 2", "cell 3"]
          to_table([@row_cell_texts])
        end

        it "should create a row with Shrink::Cell's with the order of the Cucumber cells preserved" do
          @table.rows.first.cells.collect(&:text).should eql(@row_cell_texts)
        end

      end

    end

    describe "when the Cucumber table contains multiple rows" do

      before(:all) do
        to_table((1..3).collect do |row_number|
          (1..3).collect { |column_number| "Cell #{row_number}.#{column_number}" }
        end)
      end

      describe "that each contain multiple cells" do

        it "should create a Shrink::Row for each row" do
          @table.rows.should have(3).rows
        end

        it "should preserve the order of the Cucumber rows" do
          @table.rows.each_with_index { |row, row_index| row.cells.first.text.should match(/Cell #{row_index + 1}/) }
        end

        it "should create a Shrink::Cell for each cell" do
          @table.rows.each { |row| row.cells.should have(3).cells }
        end

        it "should preserve the order of the Cucumber cells" do
          @table.rows.each_with_index do |row, row_index|
            row.cells.each_with_index do |cell, cell_index|
              cell.text.should match(/Cell #{row_index + 1}.#{cell_index + 1}/)
            end
          end
        end

      end

    end

    def to_table(cucumber_ast_table_raw)
      @raw = cucumber_ast_table_raw
      @table = @adapter.adapt(mock("Cucumber::Ast::Table",  :raw => cucumber_ast_table_raw))
    end

  end

end
