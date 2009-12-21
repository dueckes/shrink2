describe Platter::StepSuggester::Context do

  before(:each) do
    @text = "Some Text"
    @position = 8
    @scenario = mock("Scenario")
    @context = Platter::StepSuggester::Context.new(@text, @position, @scenario)
  end

  context "#text" do

    it "should return the text provided" do
      @context.text.should eql(@text)
    end

  end

  context "#texts_before" do

    it "should return the step texts until and excluding the position provided" do
      steps = (1..10).collect { |i| mock("Step", :text => "Step#{i}") }
      @scenario.stub!(:steps).and_return(steps)

      @context.texts_before.should eql(steps[0..7].collect(&:text))
    end

  end

end
