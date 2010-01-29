describe Shrink::Step do

  before(:each) do
    @step = Shrink::Step.new(:text => "Some Text")
  end

  it "should have text" do
    @step.text.should eql("Some Text")
  end

  it "should belong to a table" do
    table = Shrink::Table.new

    step = Shrink::Step.new(:table => table)

    step.table.should eql(table)
  end

  it "should belong to a scenario" do
    scenario = Shrink::Scenario.new

    step = Shrink::Step.new(:scenario => scenario)

    step.scenario.should eql(scenario)
  end

  it "should belong to a feature" do
    feature = Shrink::Feature.new
    scenario = Shrink::Scenario.new(:feature => feature)

    step = Shrink::Step.new(:scenario => scenario)

    step.feature.should eql(feature)
  end

  it "should belong to a folder" do
    folder = Shrink::Folder.new
    feature = Shrink::Feature.new(:folder => folder)
    scenario = Shrink::Scenario.new(:feature => feature)

    step = Shrink::Step.new(:scenario => scenario)

    step.folder.should eql(folder)
  end

  it "should be a Shrink::FeatureSummaryChangeObserver" do
    Shrink::Step.include?(Shrink::FeatureSummaryChangeObserver).should be_true
  end

  it "should be a Shrink::Cucumber::Adapter::AstStepAdapter" do
    Shrink::Step.include?(Shrink::Cucumber::Adapter::AstStepAdapter).should be_true
  end

  it "should be a Shrink::Cucumber::Formatter::StepFormatter" do
    Shrink::Step.include?(Shrink::Cucumber::Formatter::StepFormatter).should be_true
  end

  context "#valid?" do

    before(:each) do
      @step = Shrink::Step.new
    end

    describe "when text has been provided" do

      describe "whose length is less than 256 characters" do

        before(:each) do
          @step.text = "a" * 255
        end

        it "should return true" do
          @step.should be_valid
        end

      end

      describe "whose length is 256 characters" do

        before(:each) do
          @step.text = "a" * 256
        end

        it "should return true" do
          @step.should be_valid
        end

      end

      describe "whose length is greater than 256 characters" do

        before(:each) do
          @step.text = "a" * 257
        end

        it "should return false" do
          @step.should_not be_valid
        end

      end

      describe "that is empty" do

        before(:each) do
          @step.text = ""
        end

        it "should return false" do
          @step.should_not be_valid
        end

      end

    end


    describe "when a table has been provided" do

      before(:each) do
        @step.table = Shrink::Table.new
        @step.text = nil
      end

      it "should return true" do
        @step.should be_valid
      end

    end

    describe "when neither text or a table have been provided" do

      it "should return false" do
        @step.should_not be_valid
      end

    end

  end

  context "#calculate_summary" do

    describe "when text has been provided" do

      it "should return the text" do
        @step.calculate_summary.should eql("Some Text")
      end

    end

    describe "when a table has been provided" do

      before(:each) do
        @step.text = nil
        @step.table = @table = Shrink::Table.new
      end

      it "should return the summary calculated from the table" do
        @table.stub!(:calculate_summary).and_return("Table Summary")

        @step.calculate_summary.should eql("Table Summary")
      end

    end

  end

end
