describe Shrink::Project do

  before(:each) do
    @project = Shrink::Project.new
  end

  it "should have a name" do
    @project.name = "Some project name"

    @project.name.should eql("Some project name")
  end

  it "should have a root folder" do
    root_folder = Shrink::Folder.new(:name => "Some Folder")
    @project.root_folder = root_folder

    @project.root_folder = root_folder
  end

  it "should have folders" do
    folders = (1..3).collect do |i|
      folder = Shrink::Folder.new(:name => "Folder #{i}")
      @project.folders << folder
      folder
    end

    @project.folders.should eql(folders)
  end

  it "should have users" do
    users = (1..3).collect do |i|
      user = Shrink::User.new(:login => "Login #{i}")
      @project.users << user
      user
    end

    @project.users.should eql(users)
  end

  it "should have features" do
    features = (1..3).collect do |i|
      feature = Shrink::Feature.new(:title => "Feature #{i}")
      @project.features << feature
      feature
    end

    @project.features.should eql(features)
  end

  it "should have tags" do
    tags = (1..3).collect do |i|
      tag = Shrink::Tag.new(:name => "Tag #{i}")
      @project.tags << tag
      tag
    end

    @project.tags.should eql(tags)
  end

  context "#steps" do

    it "should create a Shrink::ProjectSteps instance providing the project" do
      Shrink::ProjectSteps.should_receive(:new).with(@project)

      @project.steps
    end

    it "should return a Shrink::ProjectSteps instance" do
      project_steps = mock("ProjectSteps")

      Shrink::ProjectSteps.stub!(:new).and_return(project_steps)

      @project.steps.should eql(project_steps)
    end

  end

  context "#description_lines" do

    it "should create a Shrink::ProjectFeatureDescriptionLines instance providing the project" do
      Shrink::ProjectFeatureDescriptionLines.should_receive(:new).with(@project)

      @project.description_lines
    end

    it "should return a Shrink::ProjectFeatureDescriptionLines instance" do
      project_description_lines = mock("ProjectFeatureDescriptionLines")

      Shrink::ProjectFeatureDescriptionLines.stub!(:new).and_return(project_description_lines)

      @project.description_lines.should eql(project_description_lines)
    end

  end

  context "#valid?" do

    describe "when a name has been established" do

      describe "that is not blank" do

        describe "and less that 256 characters in length" do

          before(:each) do
            @project.name = "a" * 255
          end

          it "should return true" do
            @project.should be_valid
          end

        end

        describe "and 256 characters in length" do

          before(:each) do
            @project.name = "a" * 256
          end

          it "should return true" do
            @project.should be_valid
          end

        end

        describe "and greater than 256 characters in length" do

          before(:each) do
            @project.name = "a" * 257
          end

          it "should return false" do
            @project.should_not be_valid
          end

        end

      end

      describe "that is blank" do

        before(:each) do
          @project.name = ""
        end

        it "should return false" do
          @project.should_not be_valid
        end

      end

    end

    describe "when no name has been established" do

      before(:each) do
        @project.name = nil
      end

      it "should return false" do
        @project.should_not be_valid

      end

    end

  end

end
