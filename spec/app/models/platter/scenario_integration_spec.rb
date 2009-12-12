describe Platter::Scenario do

  describe "integrating with the database" do

    before(:each) do
      @feature = DatabaseModelFixture.create_feature!
    end

    context "#create!" do

      it "should not require a position" do
        scenario = Platter::Scenario.create!(:title => "Some Title", :feature => @feature)

        Platter::Scenario.exists?(scenario).should be_true
      end

    end

    context "#valid?" do

      describe "when a title is established" do

        describe "and the title is not the same as any other scenarios title in the same feature" do

          before(:each) do
            Platter::Scenario.create!(:title => "Different Title", :feature => @feature)
            @scenario = Platter::Scenario.new(:title => "Title", :feature => @feature)
          end

          it "should return true" do
            @scenario.should be_valid
          end

        end

        describe "and the title is the same as another scenarios title in the same feature" do

          before(:each) do
            Platter::Scenario.create!(:title => "Same Title", :feature => @feature)
            @scenario = Platter::Scenario.new(:title => "Same Title", :feature => @feature)
          end

          it "should return false" do
            @scenario.should_not be_valid
          end

        end

        describe "and the title is the same as another scenarios title in a different feature" do

          before(:each) do
            other_feature = DatabaseModelFixture.create_feature!(:title => "Other Feature")
            Platter::Scenario.create!(:title => "Same Title", :feature => other_feature)
            @scenario = Platter::Scenario.new(:title => "Same Title", :feature => @feature)
          end

          it "should return true" do
            @scenario.should be_valid
          end
        end

      end

    end

    context "#steps" do

      before(:each) do
        @scenario = DatabaseModelFixture.create_scenario!
      end

      describe "when steps have been added" do

        before(:each) do
          (1..3).each do |i|
            @scenario.steps << Platter::Step.new(:text => "Step Text #{i}", :position => 4 - i)
          end
          @scenario.steps(true)
        end

        it "should have the same amount of steps that have been added" do
          @scenario.steps.should have(3).steps
        end

        it "should retrieve steps ordered by position" do
          @scenario.steps.each_with_index { |step, i| step.text.should eql("Step Text #{3 - i}") }
        end

      end

    end

  end

  context "#order_steps" do

    describe "when provided a list of all step ids" do

      before(:each) do
        @scenario = DatabaseModelFixture.create_scenario!
        @steps = (1..3).collect { |i| Platter::Step.create!(:scenario => @scenario, :text => "Step#{i}") }
      end

      describe "whose order corresponds with the position of the steps" do

        before(:each) do
          @scenario.order_steps(@steps.collect(&:id))
        end

        it "should leave the order of the steps unchanged" do
          @scenario.steps.should eql(@steps)
        end

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
