describe Shrink::Row do

  describe "integrating with the database" do
    include_context "database integration"

    context "#cells" do

      describe "when cells have been added" do

        before(:each) do
          @table = Shrink::Table.create!
          @row = Shrink::Row.create!(:table => @table)
          @cells = (1..3).collect { |i| Shrink::Cell.create!(:row => @row, :text => "Cell #{i}") }
          @row.reload
        end

        it "should have the same amount of cells that have been added" do
          @row.should have(3).cells
        end

        it "should be ordered in the position they were added" do
          @row.cells.should eql(@cells)
        end

        it "should all be destroyed when the row is destroyed" do
          @row.destroy

          @cells.each  { |cell| Shrink::Cell.find_by_id(cell.id).should be_nil }
        end

      end

    end

  end

end
