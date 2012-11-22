describe Shrink::Table do

  describe "integrating with the database" do
    include_context "database integration"

    context "#rows" do

      describe "when rows have been added" do

        before(:each) do
          @table = Shrink::Table.create!
          @rows = (1..3).collect { Shrink::Row.create!(:table => @table) }
          @table.reload
        end

        it "should have the same amount of rows that have been added" do
          @table.should have(3).rows
        end

        it "should be ordered in the position they were added" do
          @table.rows.should eql(@rows)
        end

        it "should all be destroyed when the table is destroyed" do
          @table.destroy

          @rows.each { |row| Shrink::Row.find_by_id(row.id).should be_nil }
        end

      end

    end

    context "#create_with_dimensions_and_texts!" do

      describe "when provided valid dimensions and texts matching the dimensions" do

        before(:all) do
          @number_of_rows = @number_of_columns = 3
          @texts = (1..@number_of_rows).collect do |row_number|
            (1..@number_of_columns).collect { |column_number| "Text Row #{row_number}, Column #{column_number}" }
          end.flatten
          @table = Shrink::Table.create_with_dimensions_and_texts!(
                  { :rows => @number_of_rows, :columns => @number_of_columns }, @texts)
          establish_rows_and_cells
        end

        it "should create a persisted table" do
          @table.should_not be_a_new_record
        end

        it "should create the number of rows specified" do
          @table.should have(@number_of_rows).rows
        end

        it "should persist each row" do
          @rows.each { |row| row.should_not be_a_new_record }
        end

        it "should create the number of columns specified in each row" do
          @rows.each { |row| row.should have(@number_of_columns).cells }
        end

        it "should persist each cell" do
          @cells.each { |cell| cell.should_not be_a_new_record }
        end

        it "should create cells with the text provided" do
          @cells.each_with_index { |cell, i| cell.text.should eql(@texts[i]) }
        end

      end

    end

    context "#update_with_dimensions_and_texts!" do

      describe "when the table contains data" do

        before(:all) do
          @original_texts = (1..2).collect do |row_number|
            (1..2).collect { |column_number| "Text Row #{row_number}, Column #{column_number}" }
          end.flatten
          @table = Shrink::Table.create_with_dimensions_and_texts!({ :rows => 2, :columns => 2 }, @original_texts)
        end

        describe "and rows and columns are added" do

          before(:all) do
            update_with_dimensions_and_texts!(:rows => 3, :columns => 3) do |row_number, column_number|
              "Text Row #{row_number}, Column #{column_number}"
            end
          end

          it "should create the added rows" do
            @rows.should have(3).rows
          end

          it "should create the added columns in each row" do
            @rows.each { |row| row.should have(3).cells }
          end

          it "should leave cells with the updates texts" do
            @cells.collect(&:text).should eql(@texts)
          end

        end

        describe "and rows and columns are removed" do

          before(:all) do
            update_with_dimensions_and_texts!(:rows => 1, :columns => 1) do |row_number, column_number|
              "Text Row #{row_number}, Column #{column_number}"
            end
          end

          it "should destroy the removed rows" do
            @rows.should have(1).row

          end

          it "should destroy the removed columns from each row" do
            @rows.each { |row| row.should have(1).cell }
          end

          it "should leave cells with the updated texts" do
            @cells.collect(&:text).should eql(@texts)
          end

        end

        describe "and cell text changes are made" do

          before(:all) do
            update_with_dimensions_and_texts!(:rows => 2, :columns => 2) do |row_number, column_number|
              "Updated Text Row #{row_number}, Column #{column_number}"
            end
          end

          it "should not alter the number of rows" do
            @rows.should have(2).rows
          end

          it "should not alter the number of cells in each row" do
            @rows.each { |row| row.should have(2).cells }
          end

          it "should leave cells with the updated texts" do
            @cells.collect(&:text).should eql(@texts)
          end

        end

      end

      def update_with_dimensions_and_texts!(dimensions, &text_block)
        @texts = (1..dimensions[:rows]).collect do |row_number|
          (1..dimensions[:columns]).collect { |column_number| text_block.call(row_number, column_number) }
        end.flatten
        @table.update_with_dimensions_and_texts!(dimensions, @texts)
        establish_rows_and_cells
      end

    end

    def establish_rows_and_cells
      @rows = @table.rows
      @cells = @rows.collect(&:cells).flatten
    end

  end

end
