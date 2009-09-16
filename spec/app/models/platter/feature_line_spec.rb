module Platter
  describe FeatureLine do

    it "should have text" do
      line = FeatureLine.new(:text => "Some Text")

      line.text.should eql("Some Text")
    end

    it "should belong to a feature" do
      feature = Feature.new

      line = FeatureLine.new(:feature => feature)

      line.feature.should eql(feature)
    end

    it "should belong to a package" do
      package = Package.new
      feature = Feature.new(:package => package)

      line = FeatureLine.new(:feature => feature)

      line.package.should eql(package)
    end

    describe "#valid?" do

      describe "when text has been provided" do

        before(:each) do
          @line = FeatureLine.new(:text => "Some Text")
        end

        it "should return true" do
          @line.should be_valid
        end

      end

      describe "when no text has been provided" do

        before(:each) do
          @line = FeatureLine.new
        end

        it "should return false" do
          @line.should_not be_valid
        end

      end

    end

    describe '#as_text' do
      it 'should return the text attribute' do
        text = 'feature text'
        FeatureLine.new(:text => text).as_text.should eql text
      end
    end
  end
end