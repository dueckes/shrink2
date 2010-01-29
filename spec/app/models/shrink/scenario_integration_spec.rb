describe Shrink::Scenario do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration
    it_should_behave_like ClearDatabaseAfterEach
    
    before(:each) do
      @feature = create_feature!
    end

    context "#create!" do

      it "should not require a position" do
        scenario = Shrink::Scenario.create!(:title => "Some Title", :feature => @feature)

        Shrink::Scenario.exists?(scenario).should be_true
      end

    end

    context "#valid?" do

      describe "when a title is established" do

        describe "and the title is not the same as any other scenarios title in the same feature" do

          before(:each) do
            Shrink::Scenario.create!(:title => "Different Title", :feature => @feature)
            @scenario = Shrink::Scenario.new(:title => "Title", :feature => @feature)
          end

          it "should return true" do
            @scenario.should be_valid
          end

        end

        describe "and the title is the same as another scenarios title in the same feature" do

          before(:each) do
            Shrink::Scenario.create!(:title => "Same Title", :feature => @feature)
            @scenario = Shrink::Scenario.new(:title => "Same Title", :feature => @feature)
          end

          it "should return false" do
            @scenario.should_not be_valid
          end

        end

        describe "and the title is the same as another scenarios title in a different feature" do

          before(:each) do
            other_feature = create_feature!(:title => "Other Feature")
            Shrink::Scenario.create!(:title => "Same Title", :feature => other_feature)
            @scenario = Shrink::Scenario.new(:title => "Same Title", :feature => @feature)
          end

          it "should return true" do
            @scenario.should be_valid
          end
        end

      end

    end

    context "#steps" do

      before(:each) do
        @scenario = create_scenario!
      end

      describe "when steps have been added" do

        before(:each) do
          @steps = (1..3).collect do |i|
            Shrink::Step.create!(:text => "Step Text #{i}", :position => 4 - i, :scenario => @scenario)
          end
          @scenario.steps(true)
        end

        it "should have the same amount of steps that have been added" do
          @scenario.steps.should have(3).steps
        end

        it "should retrieve steps ordered by position" do
          @scenario.steps.each_with_index { |step, i| step.text.should eql("Step Text #{3 - i}") }
        end

        it "should all be destroyed when the scenario is destroyed" do
          @scenario.destroy

          @steps.each { |step| Shrink::Step.find_by_id(step.id).should be_nil }
        end

      end

    end

    context "#order_steps" do

      describe "when provided a list of all step ids" do

        before(:each) do
          @scenario = create_scenario!
          @steps = (1..3).collect { |i| Shrink::Step.create!(:scenario => @scenario, :text => "Step#{i}") }
        end

        describe "whose order corresponds with the position of the steps" do

          before(:each) do
            @scenario.order_steps(@steps.collect(&:id))
          end
        end


        it "should leave the order of the steps unchanged" do
          @scenario.steps.should eql(@steps)
        end

        describe "whose order does not correspond with the position of the steps" do

          before(:each) do
            @scenario.order_steps(@steps.collect(&:id).reverse)
          end

          it "should order the steps based on the position of their id in the list" do
            @scenario.steps.should eql(@steps.reverse)
          end

        end

      end

    end

  end

end
