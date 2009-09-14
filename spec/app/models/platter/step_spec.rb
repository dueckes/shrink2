describe Platter::Step do

  it "should have text" do
    step = Platter::Step.new(:text => "Some Text")

    step.text.should eql("Some Text")
  end

  describe "#valid?" do

    describe "when text has been provided" do

      before(:each) do
        @step = Platter::Step.new(:text => "Some Text")
      end

      it "should return true" do
        @step.should be_valid

      end

    end

    describe "when no text has been provided" do

      before(:each) do
        @step = Platter::Step.new
      end

      it "should return false" do
        @step.should_not be_valid
      end

    end

  end

end
