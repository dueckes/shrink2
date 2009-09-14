describe Platter::Scenario do

  describe "integrating with the database" do

    before(:each) do
      @feature = DatabaseModelFixture.create_feature!
    end

    describe "#create!" do

      it "should not require a position" do
        scenario = Platter::Scenario.create!(:title => "Some Title", :feature => @feature)

        Platter::Scenario.exists?(scenario).should be_true
      end

    end

    describe "#steps" do

      before(:each) do
        @scenario = DatabaseModelFixture.create_scenario!
      end

      describe "when steps have been added" do

        before(:each) do
          (1..3).each do |i|
            @scenario.steps << Platter::Step.new(:text => "Step Text #{i}", :position => 4 - i)
          end
        end

        it "should have the same amount of steps that have been added" do
          @scenario.steps.should have(3).steps
        end

        it "should retrieve steps ordered by position" do
          @scenario.steps.each_with_index do |step, i|
            step.text.should eql("Step Text #{3 - i}")
            step.position.should eql(i + 1)
          end
        end

      end

    end

  end

end
