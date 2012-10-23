describe Shrink::Row do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    context "#cells" do

      describe "when cells have been added" do

        before(:all) do
          @table = Shrink::Table.create!
          @row = Shrink::Row.create!(:table => @table)
          @cells = (1..3).collect { |i| Shrink::Cell.create!(:row => @row, :text => "Cell #{i}") }
          @row.cells(true)
        end

        it "should have the same amount of cells that have been added" do
          @row.cells.should have(3).cells
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
