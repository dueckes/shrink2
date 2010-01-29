describe Shrink::Row do

  before(:each) do
    @table = Shrink::Table.new
    @row = Shrink::Row.new
  end

  it "should belong to a table" do
    @row.table = @table

    @row.table.should eql(@table)
  end

  it "should have cells" do
    cells = (1..3).collect { |i| Shrink::Cell.new(:text => "Cell #{i}") }

    @row.cells.concat(cells)

    @row.cells.should eql(cells)
  end

  context "#row_type" do

    describe "when the row is the first in the table" do

      before(:each) do
        add_to_table(@row)
      end

      it "should return Shrink::Row::TYPE_HEADER" do
        @row.row_type.should eql(Shrink::Row::TYPE_HEADER)
      end

    end

    describe "when the row is after the first in the table" do

      before(:each) do
        add_to_table(Shrink::Row.new, @row, Shrink::Row.new)
      end

      it "should return Shrink::Row::TYPE_DATA" do
        @row.row_type.should eql(Shrink::Row::TYPE_DATA)
      end

    end

    def add_to_table(*rows)
      rows.each do |row|
        row.table = @table
        @table.rows << row
      end
    end

  end

end
