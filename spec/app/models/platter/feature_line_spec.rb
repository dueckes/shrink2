module Platter
  describe FeatureLine do

    before(:each) do
      @line = FeatureLine.new(:text => "Some Text")
    end

    it "should have text" do
      @line.text.should eql("Some Text")
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

    it "should be a Platter::FeatureSummaryChangeObserver" do
      FeatureLine.include?(Platter::FeatureSummaryChangeObserver).should be_true
    end

    it "should be a Platter::Cucumber::Formatter::TextFormatter" do
      FeatureLine.include?(Platter::Cucumber::Formatter::TextFormatter).should be_true
    end

    context "#valid?" do

      before(:each) do
        @line = FeatureLine.new
      end

      describe "when text has been provided" do

        describe "whose length is less than 256 characters" do

          before(:each) do
            @line.text = "a" * 255
          end

          it "should return true" do
            @line.should be_valid
          end

        end

        describe "whose length is 256 characters" do

          before(:each) do
            @line.text = "a" * 256
          end

          it "should return true" do
            @line.should be_valid
          end

        end

        describe "whose length is greater than 256 characters" do

          before(:each) do
            @line.text = "a" * 257
          end

          it "should return false" do
            @line.should_not be_valid
          end

        end

        describe "that is empty" do

          before(:each) do
            @line.text = ""
          end

          it "should return false" do
            @line.should_not be_valid
          end

        end

      end

      describe "and no text has been provided" do

        before(:each) do
          @line.text = nil
        end

        it "should return false" do
          @line.should_not be_valid
        end

      end

    end

    context "#summarize" do

      it "should return the text" do
       @line.summarize.should eql("Some Text")
      end

    end

  end

end
