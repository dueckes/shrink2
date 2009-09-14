describe Platter::Step do

  describe "Integrating with the database" do

    before(:each) do
      @scenario = DatabaseModelFixture.create_scenario!
    end

    describe "#create!" do

      it "should not require a position" do
        step = Platter::Step.create!(:text => "Some Text", :scenario => @scenario)

        Platter::Step.exists?(step).should be_true
      end

    end

  end

end
