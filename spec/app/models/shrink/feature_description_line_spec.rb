module Shrink
  describe FeatureDescriptionLine do

    before(:each) do
      @line = FeatureDescriptionLine.new(:text => "Some Text")
    end

    it "should have text" do
      @line.text.should eql("Some Text")
    end

    it "should belong to a feature" do
      feature = Feature.new

      line = FeatureDescriptionLine.new(:feature => feature)

      line.feature.should eql(feature)
    end

    it "should belong to a folder" do
      folder = Folder.new
      feature = Feature.new(:folder => folder)

      line = FeatureDescriptionLine.new(:feature => feature)

      line.folder.should eql(folder)
    end

    it "should be a Shrink::FeatureSummaryChangeObserver" do
      FeatureDescriptionLine.include?(Shrink::FeatureSummaryChangeObserver).should be_true
    end

    it "should be a Shrink::Cucumber::Formatter::TextFormatter" do
      FeatureDescriptionLine.include?(Shrink::Cucumber::Formatter::TextFormatter).should be_true
    end

    context "#valid?" do

      before(:each) do
        @line = FeatureDescriptionLine.new
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

    context "#calculate_summary" do

      it "should return the text" do
       @line.calculate_summary.should eql("Some Text")
      end

    end

  end

end
