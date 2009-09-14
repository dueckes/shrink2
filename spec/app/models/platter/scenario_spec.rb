describe Platter::Scenario do

  it "should have a title" do
    scenario = Platter::Scenario.new(:title => "Some Title")

    scenario.title.should eql("Some Title")
  end

  it "should have steps" do
    scenario = Platter::Scenario.new
    steps = (1..3).collect do |i|
      step = create_step(:text => "Step#{i}")
      scenario.steps << step
      step
    end

    scenario.steps.should eql(steps)
  end

  describe "#valid?" do

    before(:each) do
      @scenario = Platter::Scenario.new(:title => "Some Title")
      @scenario.steps << create_step(:text => "Some Step")
    end

    describe "when a title is established" do

      it "should return true" do
        @scenario.should be_valid
      end

    end

    describe "when no title is established" do

      before(:each) do
        @scenario.title = nil
      end

      it "should return false" do
        @scenario.should_not be_valid
      end

    end
    
    describe "when no steps have been added" do

      before(:each) do
        @scenario.steps.clear
      end

      it "should return true" do
        @scenario.should be_valid
      end

    end

    describe "when one step has been added" do

      it "should return true" do
        @scenario.should be_valid
      end

    end

    describe "when many steps have been added" do

      it "should return true" do
        (1..3).collect { |i| @scenario.steps << create_step(:text => "Step#{i}") }

        @scenario.should be_valid
      end

    end

  end

  def create_step(attributes)
    Platter::Step.new(attributes)
  end

end
