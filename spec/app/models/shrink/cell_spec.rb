describe Shrink::Cell do

  before(:each) do
    @cell = Shrink::Cell.new(:text => "Cell Text")
  end

  it "should have text" do
    @cell.text.should eql("Cell Text")

  end

  it "should belong to a row" do
    row = Shrink::Row.new

    @cell.row = row

    @cell.row.should eql(row)
  end

  context "#table" do

    before(:each) do
      @table = Shrink::Table.new
      @cell.row = Shrink::Row.new(:table => @table)
    end

    it "should return the rows table" do
      @cell.table.should eql(@table)
    end

  end

end
