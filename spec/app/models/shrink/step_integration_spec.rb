describe Shrink::Step do

  describe "Integrating with the database" do
    include_context "database integration"

    before(:all) do
      @scenario = create_scenario!
    end

    context "#create!" do

      it "should not require a position" do
        step = Shrink::Step.create!(:text => "Some Text", :scenario => @scenario)

        Shrink::Step.exists?(step).should be_true
      end

    end

    context "#destroy" do

      describe "when the step contains a table" do

        before(:all) do
          @table = create_table!(:rows => 1, :columns => 1)
          @step = Shrink::Step.create!(:scenario => @scenario, :table => @table)
        end

        it "should destroy the table" do
          @step.destroy

          Shrink::Table.find_by_id(@table.id).should be_nil
        end

      end

    end

  end

end
