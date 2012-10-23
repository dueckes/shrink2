describe Shrink::Tag do

  it "should have a name" do
    tag = Shrink::Tag.new(:name => "Some Tag")

    tag.name.should eql("Some Tag")
  end

  it "should have a project" do
    project = Shrink::Project.new(:name => "Some Project")

    tag = Shrink::Tag.new(:project => project)

    tag.project.should eql(project)
  end

  it "should have features" do
    tag = Shrink::Tag.new
    features = add_features_to(tag)

    tag.features.should eql(features)
  end

  it "should have scenarios" do
    tag = Shrink::Tag.new
    scenarios = add_scenarios_to(tag)

    tag.scenarios.should eql(scenarios)
  end

  it "should have models combining features and scenarios" do
    tag = Shrink::Tag.new

    features = add_features_to(tag)
    scenarios = add_scenarios_to(tag)

    tag.models.should eql(features.concat(scenarios))
  end

  it "should be a Shrink::FeatureSummaryChangeObserver" do
    Shrink::Tag.include?(Shrink::FeatureSummaryChangeObserver).should be_true
  end

  it "should be a Shrink::Cucumber::Formatter::TagFormatter" do
    Shrink::Tag.include?(Shrink::Cucumber::Formatter::TagFormatter).should be_true
  end

  context "#valid?" do

    before(:each) do
      @tag = Shrink::Tag.new(:name => "Some Name")
    end

    describe "when a name has been established" do

      describe "whose length is less than 256 characters" do

        before(:each) do
          @tag.name = "a" * 255
        end

        it "should return true" do
          @tag.should be_valid
        end

      end

      describe "whose length is 256 characters" do

        before(:each) do
          @tag.name = "a" * 256
        end

        it "should return true" do
          @tag.should be_valid
        end

      end

      describe "whose length is greater than 256 characters" do

        before(:each) do
          @tag.name = "a" * 257
        end

        it "should return false" do
          @tag.should_not be_valid
        end

      end

      describe "that is empty" do

        before(:each) do
          @tag.name = ""
        end

        it "should return false" do
          @tag.should_not be_valid
        end

      end

    end

    describe "when a name has not been established" do

      before(:each) do
        @tag.name = nil
      end

      it "should return false" do
        @tag.should_not be_valid
      end

    end

  end

  context "#calculate_summary" do

    before(:each) do
      @tag = Shrink::Tag.new(:name => "Some Name")
    end

    it "should return the name of the tag" do
      @tag.calculate_summary.should eql("Some Name")
    end

  end

  def add_features_to(tag)
    (1..3).collect do |i|
      feature = Shrink::Feature.new(:title => "Feature Title#{i}")
      tag.features << feature
      feature
    end
  end

  def add_scenarios_to(tag)
    (1..3).collect do |i|
      scenario = Shrink::Scenario.new(:title => "Scenario Title#{i}")
      tag.scenarios << scenario
      scenario
    end
  end

end
