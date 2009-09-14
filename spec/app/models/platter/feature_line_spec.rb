describe Platter::FeatureLine do

  it "should have text" do
    line = Platter::FeatureLine.new(:text => "Some Text")

    line.text.should eql("Some Text")
  end

  it "should belong to a feature" do
    feature = Platter::Feature.new

    line = Platter::FeatureLine.new(:feature => feature)
    
    line.feature.should eql(feature)
  end

  describe "#valid?" do

    describe "when text has been provided" do

      before(:each) do
        @line = Platter::FeatureLine.new(:text => "Some Text")
      end

      it "should return true" do
        @line.should be_valid
      end

    end

    describe "when no text has been provided" do

      before(:each) do
        @line = Platter::FeatureLine.new
      end

      it "should return false" do
        @line.should_not be_valid
      end

    end

  end

end
