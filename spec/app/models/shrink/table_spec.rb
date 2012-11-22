describe Shrink::Table do

  it "should have rows" do
    table = Shrink::Table.new

    rows = (1..3).collect do
      table.rows << (row = Shrink::Row.new(:table => table))
      row
    end

    table.rows.should eql(rows)
  end

  it "should be a Shrink::Cucumber::Formatter::TableFormatter" do
    Shrink::Table.include?(Shrink::Cucumber::Formatter::TableFormatter).should be_true
  end

  it "should be a Shrink::Cucumber::Ast::Adapter::TableAdapter" do
    Shrink::Table.include?(Shrink::Cucumber::Ast::Adapter::TableAdapter).should be_true
  end

  context "#header_row" do

    describe "when the table has one row" do

      before(:each) do
        create_table(:rows => 1)
      end

      it "should return the row" do
        @table.header_row.should eql(@rows.first)
      end

    end

    describe "when the table multiple rows" do

      before(:each) do
        create_table(:rows => 3)
      end

      it "should return the first row" do
        @table.header_row.should eql(@rows.first)
      end

    end

  end

  context "#data_rows" do

    describe "when the table has one row" do

      before(:each) do
        create_table(:rows => 1)
      end

      it "should return an empty array" do
        @table.data_rows.should eql([])
      end

    end

    describe "when the table multiple rows" do

      before(:each) do
        create_table(:rows => 3)
      end

      it "should return the rows other than the first row" do
        @table.data_rows.should eql(@rows[1..-1])
      end

    end

  end

  context "#new_empty!" do

    before(:all) do
      @table = Shrink::Table.new_empty
      @rows = @table.rows
      @cells = @rows.collect(&:cells).flatten
    end

    it "should create a table" do
      @table.should_not be_nil
    end

    it "should not persist the table" do
      @table.should be_a_new_record
    end

    it "should create two rows" do
      @rows.should have(2).row
    end

    it "should create rows each containing one cell" do
      @rows.each { |row| row.should have(1).cell }
    end

    it "should create cells with no text" do
      @cells.each { |cell| cell.text.should be_empty }
    end

  end

  context "#rows_with_padded_text" do

    describe "when the table contains one row" do

      before(:all) do
        create_table(:rows => 1, :columns => 3) do |column_number, row_number|
          "Row #{row_number}, Column #{column_number}"
        end
      end

      it "should return an array containing an array of the rows' cells text" do
        @table.rows_with_padded_cell_text.should eql([@rows.first.cells.collect(&:text)])
      end

    end

    describe "when the table contains multiple rows" do

      describe "and all cells contains text of the same length" do

        before(:all) do
          create_table(:rows => 3, :columns => 3) do |column_number, row_number|
            "Row #{row_number}, Column #{column_number}"
          end
        end

        it "should return an array containing an array for each rows' cells text" do
          @table.rows_with_padded_cell_text.should eql(@rows.collect { |row| row.cells.collect(&:text) })
        end

      end

      describe "and cells contain text having different lengths" do

        before(:all) do
          create_table(:rows => 3, :columns => 3) { |column_number, row_number| "W" * column_number * row_number }
        end

        it "should return cell texts whose length matches the longest in the column left-aligned and padded with spaces" do
          @table.rows_with_padded_cell_text.should eql([["W  ", "WW    ", "WWW      "],
                                                        ["WW ", "WWWW  ", "WWWWWW   "],
                                                        ["WWW", "WWWWWW", "WWWWWWWWW"]])
        end

      end

    end

  end

  context "#calculate_summary" do

    describe "when the table contains multiple rows" do

      before(:all) do
        create_table(:rows => 3, :columns => 3) do |column_number, row_number|
          "#{"X" * column_number}, #{"Y" * row_number}"
        end
        @summary_lines = @table.calculate_summary.split("\n")
      end

      describe "the rows" do

        it "should be converted to lines ordered by position" do
          (1..3).each { |i| @summary_lines[i - 1].should match(/#{"Y" * i}/) }
        end

        it "should have their cells texts divided by a textile compliant separator" do
          @summary_lines.should eql(["|X, Y|XX, Y|XXX, Y|",
                                     "|X, YY|XX, YY|XXX, YY|",
                                     "|X, YYY|XX, YYY|XXX, YYY|"])
        end

      end

    end

  end

  def create_table(dimensions, &text_block)
    number_of_rows = dimensions[:rows]
    number_of_columns = dimensions[:columns] || 0
    @table = Shrink::Table.new
    (1..number_of_rows).each do |row_number|
      @table.rows << (row = Shrink::Row.new(:table => @table))
      (1..number_of_columns).each do |column_number|
        row.cells << Shrink::Cell.new(:row => row, :text => text_block.call(column_number, row_number))
      end
    end
    @rows = @table.rows
  end

end
