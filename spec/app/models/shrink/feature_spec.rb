describe Shrink::Feature do

  it "should belong to a project" do
    project = Shrink::Project.new(:name => "Some Project")

    feature = Shrink::Feature.new(:project => project)

    feature.project.should eql(project)
  end

  it "should belong to a folder" do
    folder = Shrink::Folder.new(:name => "Some folder")

    feature = Shrink::Feature.new(:folder => folder)

    feature.folder.should eql(folder)
  end

  it "should have a title" do
    feature = Shrink::Feature.new(:title => "Some Title")

    feature.title.should eql("Some Title")
  end

  it "should have tags" do
    feature = Shrink::Feature.new

    tags = (1..3).collect do |i|
      tag = create_mock_tag(:name => "Tag#{i}")
      feature.tags << tag
      tag
    end

    feature.tags.should eql(tags)
  end

  it "should have feature description lines" do
    feature = Shrink::Feature.new

    description_lines = (1..3).collect do |i|
      description_line = create_mock_description_line(:text => "Description Line #{i}")
      feature.description_lines << description_line
      description_line
    end

    feature.description_lines.should eql(description_lines)
  end

  it "should have scenarios" do
    feature = Shrink::Feature.new

    scenarios = (1..3).collect do |i|
      scenario = create_mock_scenario(:title => "Scenario #{i}")
      feature.scenarios << scenario
      scenario
    end

    feature.scenarios.should eql(scenarios)
  end

  it "should be Shrink::Taggable" do
    Shrink::Feature.include?(Shrink::Taggable).should be_true
  end

  it "should be a Shrink::FeatureSummaryChangeObserver" do
    Shrink::Feature.include?(Shrink::FeatureSummaryChangeObserver).should be_true
  end

  it "should be a Shrink::Cucumber::Ast::Adapter::FeatureAdapter" do
    Shrink::Feature.include?(Shrink::Cucumber::Ast::Adapter::FeatureAdapter).should be_true
  end

  it "should be a Shrink::Cucumber::Formatter::FeatureFormatter" do
    Shrink::Feature.include?(Shrink::Cucumber::Formatter::FeatureFormatter).should be_true
  end

  context "#update_summary!" do

    before(:each) do
      @feature = Shrink::Feature.new
    end

    it "should invoke update_attributes!" do
      @feature.should_receive(:update_attributes!)

      @feature.update_summary!
    end

    it "should update the summary to a value retrieved from summarizing the feature" do
      @feature.stub!(:calculate_summary).and_return("Some Summary")
      @feature.stub!(:update_attributes!).with(:summary => "Some Summary")

      @feature.update_summary!
    end

  end

  context "#search_result_preview" do

    before(:each) do
      @feature = Shrink::Feature.new
      @summary = mock("Summary", :null_object => true)
      @feature.stub!(:summary).and_return(@summary)
    end

    it "should preview 1 line surrounding the line containing the search text in the summary" do
      @summary.should_receive(:preview).with("search text", 1)

      @feature.search_result_preview("search text")
    end

  end

  context "#calculate_summary" do

    before(:each) do
      @feature = Shrink::Feature.new(:title => "Some Feature Title")
    end

    describe "when the feature is fully populated" do

      before(:each) do
        @tags = (1..3).collect { |i| mock("Tag#{i}", :calculate_summary => "tag_#{i}") }
        @feature.stub!(:tags).and_return(@tags)
        @description_lines = (1..3).collect { |i| mock("FeatureDescriptionLine#{i}", :calculate_summary => "Feature Description Line #{i}") }
        @feature.stub!(:description_lines).and_return(@description_lines)
        @scenarios = (1..3).collect { |i| mock("Scenario#{i}", :calculate_summary => "Scenario #{i}") }
        @feature.stub!(:scenarios).and_return(@scenarios)

        @summary_lines = @feature.calculate_summary.split("\n")
      end

      describe "the feature title" do

        it "should be on the first line of text" do
          @summary_lines.first.should include("Some Feature Title")
        end

      end

      describe "the tag summaries" do

        it "should be space delimited on the second line of text" do
          @summary_lines.second.should eql("tag_1 tag_2 tag_3")
        end

      end


      describe "the description line summaries" do

        it "should occupy a line each and be displayed directly after the feature title" do
          @summary_lines[2..4].should eql(["Feature Description Line 1", "Feature Description Line 2", "Feature Description Line 3"])
        end

      end

      describe "the scenario summaries" do

        it "should be divided from the feature description lines by an empty line" do
          @summary_lines[5].should be_empty
        end

        it "should occupy a line each divided by an empty line" do
          @summary_lines[6..10].should eql(["Scenario 1", "", "Scenario 2", "", "Scenario 3"])
        end

      end

      it "should not modify the feature title" do
        @feature.title.should eql("Some Feature Title")
      end

    end

  end

  context "#base_filename" do

    before(:each) do
      @title = "Some Title"
      @feature = Shrink::Feature.new(:title => @title)
    end

    it "should return the fileized version of the feature title" do
      @title.stub!(:fileize).and_return("Fileized title")

      @feature.base_filename.should eql("Fileized title")
    end

  end

  context "#project=" do

    before(:each) do
      @feature = Shrink::Feature.new
      @project = Shrink::Project.new
    end

    it "should associate the features tags with the project" do
      feature_tags = mock("FeatureTags")
      feature_tags.should_receive(:project=).with(@project)

      @feature.stub!(:tags).and_return(feature_tags)

      @feature.project = @project
    end

  end

  context "#folder=" do

    describe "when the folder is associated with a project" do

      before(:each) do
        @project = Shrink::Project.new(:name => "Project Name")
        @folder = Shrink::Folder.new(:project => @project)
      end

      it "should associate the folders project with the feature" do
        feature = Shrink::Feature.new(:folder => @folder)

        feature.project.should eql(@project)
      end

    end

    describe "when the folder is not associated with a project" do

      before(:each) do
        @folder = Shrink::Folder.new
        @feature = Shrink::Feature.new(:project => Shrink::Project.new(:name => "Some Project"))
      end

      it "should establish a nil project on the feature" do
        @feature.folder = @folder

        @feature.project.should be_nil
      end

    end


    describe "when the feature does not belong to a folder" do

      before(:each) do
        @feature = Shrink::Feature.new
      end

      it "should return nil" do
        @feature.project.should eql(nil)
      end

    end

  end

  context "#feature" do

    it "should return the feature" do
      feature = Shrink::Feature.new

      feature.feature.should eql(feature)
    end

  end

  def create_mock_tag(stubs)
    StubModelFixture.create_model(Shrink::Tag, stubs)
  end

  def create_mock_description_line (stubs)
    StubModelFixture.create_model(Shrink::FeatureDescriptionLine, stubs)
  end

  def create_mock_scenario(stubs)
    StubModelFixture.create_model(Shrink::Scenario, stubs)
  end

end
