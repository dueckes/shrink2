describe Shrink::Folder do

  before(:each) do
    @project = Shrink::Project.new(:name => "Project")
    @project_root_folder = Shrink::Folder.new(:name => "Root Folder", :project => @project)
    @project.root_folder = @project_root_folder

    @folder = Shrink::Folder.new(:name => "Some Name")
  end

  it "should have a name" do
    @folder.name.should eql("Some Name")
  end

  it "should have a parent" do
    parent = Shrink::Folder.new(:name => "Parent Folder Name")
    @folder.parent = parent

    @folder.parent.should eql(parent)
  end

  it "should have a project" do
    project = Shrink::Project.new(:name => "Project Name")
    @folder.project = project

    @folder.project.should eql(project)
  end

  it "should have children" do
    children = (1..3).collect do |i|
      child = Shrink::Folder.new(:name => "Child #{i} Folder Name")
      @folder.children << child
      child
    end

    @folder.children.should eql(children)
  end

  it "should have features" do
    features = (1..3).collect do |i|
      feature = Shrink::Feature.new(:title => "Feature#{i}")
      @folder.features << feature
      feature
    end

    @folder.features.should eql(features)
  end

  describe "when assigned a parent" do

    it "should be associated with the same project as the parent" do
      @folder.parent = Shrink::Folder.new(:name => "Parent Folder Name", :project => @project)

      @folder.project.should eql(@project)
    end

  end

  context "#root" do

    describe "when the folder is the project root folder" do

      it "should return the folder" do
        @project_root_folder.root.should eql(@project_root_folder)
      end

    end

    describe "when the folder is a descendant of the project root folder" do

      before(:each) do
        @folder.parent = @project_root_folder
      end

      it "should return the projects root folder" do
        @folder.root.should eql(@project_root_folder)
      end

    end

  end

  context "#tree_path" do

    describe "when the folder is the project root folder" do

      it "should return an empty array" do
        @project_root_folder.tree_path.should be_empty
      end

    end

    describe "when the folder is a descendant one level deep from the project root folder" do

      before(:each) do
        @folder.parent = @project_root_folder
      end

      it "should return an array containing only the folder" do
        @folder.tree_path.should eql([@folder])
      end

    end

    describe "when the folder is descendant two levels deep from the project root folder" do

      before(:each) do
        @root_descendant = Shrink::Folder.new(
                :name => "Root Descendant Folder Name", :parent => @project_root_folder)
        @folder.parent = @root_descendant
      end

      it "should return an array containing the descendants starting with the most mature" do
        @folder.tree_path.should eql([@root_descendant, @folder])
      end

    end

    describe "when the folder is a descendant three levels deep from the project root folder" do

      before(:each) do
        @root_descendant = Shrink::Folder.new(
                :name => "Root Descendant Folder Name", :parent => @project_root_folder)
        @inner_root_descendant = Shrink::Folder.new(
                :name => "Inner Root Descendant Folder Name", :parent => @root_descendant)
        @folder.parent = @inner_root_descendant
      end

      it "should return an array containing the descendants starting with the most mature" do
        @folder.tree_path.should eql([@root_descendant, @inner_root_descendant, @folder])
      end

    end

  end

  context "#directory_path" do

    describe "when the folder is the project root folder" do

      it "should return an empty string" do
        @project_root_folder.directory_path.should be_empty
      end

    end

    describe "when the folder is a descendant one level deep from the project root folder" do

      before(:each) do
        @folder.parent = @project_root_folder
      end

      it "should return the descendants folder name" do
        @folder.directory_path.should eql(@folder.name)
      end

    end

    describe "when the folder is a descendant three levels deep from the project root folder" do

      before(:each) do
        @root_descendant = Shrink::Folder.new(
                :name => "1 Level Deep", :parent => @project_root_folder)
        @inner_root_descendant = Shrink::Folder.new(
                :name => "2 Levels Deep", :parent => @root_descendant)
        @folder.name = "3 Levels Deep"
        @folder.parent = @inner_root_descendant
      end

      it "should return the combined path of all descendant folder names" do
        @folder.directory_path.should eql(
                "#{@root_descendant.name}/#{@inner_root_descendant.name}/#{@folder.name}")
      end

    end

  end

  context "#root_sibling?" do

    describe "when the folder is a sibling one level deep from the project root folder" do

      before(:each) do
        @folder.parent = @project_root_folder
      end

      it "should return true" do
        @folder.should be_root_sibling
      end

    end

    describe "when the folder is a sibling two levels deep from the project root folder" do

      before(:each) do
        @folder.parent = Shrink::Folder.new(:name => "Root Sibling Folder", :parent => @project_root_folder)
      end

      it "should return false" do
        @folder.should_not be_root_sibling
      end

    end

  end

  context "#root?" do

    describe "when the folder is the project root folder" do

      it "should return true" do
        @project_root_folder.should be_root
      end

    end

    describe "when the folder is not the project root folder" do

      before(:each) do
        @folder.parent = @project_root_folder
      end

      it "should return false" do
        @folder.should_not be_root
      end

    end

  end

  context "#create_root_folder!" do

    describe "when provided a project" do

      it "should delegate to create! providing the project and a name of 'Root Folder'" do
        Shrink::Folder.should_receive(:create!).with(:name => "Root Folder", :project => @project)

        Shrink::Folder.create_root_folder!(@project)
      end

    end

  end

  context "#find_or_create!" do

    before(:each) do
      @project_root_folder = mock("ProjectRootFolder")
      @project = mock("Project", :root_folder => @project_root_folder)
    end

    describe "when provided a project and folder name" do

      before(:each) do
        @folder_name = "some_folder"
        @folder = mock("Folder")
      end

      it "should delegate to find_or_create_by_name_and_parent with the project root folder as parent" do
        Shrink::Folder.should_receive(:find_or_create_by_name_and_parent!).with(
                @folder_name, @project_root_folder).and_return(@folder)

        Shrink::Folder.find_or_create!(@project, @folder_name).should eql(@folder)
      end

    end

    describe "when provided a project and path" do

      before(:each) do
        @folder_names = %w(grand_parent_folder parent_folder leaf_folder)
        @folder_name = @folder_names.join("/")
        @folders = @folder_names.each { |folder_name| mock("Folder::#{folder_name}") }
        @grand_parent_folder, @parent_folder, @leaf_folder = *@folders
      end

      it "should delegate to find_or_create_by_name_and_parent! for each directory in the path with the direct ancestor as parent" do
        Shrink::Folder.should_receive(:find_or_create_by_name_and_parent!).with(
                @folder_names.first, @project_root_folder).and_return(@grand_parent_folder)
        Shrink::Folder.should_receive(:find_or_create_by_name_and_parent!).with(
                @folder_names.second, @grand_parent_folder).and_return(@parent_folder)
        Shrink::Folder.should_receive(:find_or_create_by_name_and_parent!).with(
                @folder_names.third, @parent_folder).and_return(@leaf_folder)

        Shrink::Folder.find_or_create!(@project, @folder_name).should eql(@leaf_folder)
      end

    end

  end

  context "#find_or_create_by_name_and_parent!" do

    before(:each) do
      @name = "Some Name"
      @parent = mock("Folder::Parent", :id => 8)
    end

    describe "when a folder is found" do

      before(:each) do
        @found_folder = mock("Folder")
      end

      it "should return the folder" do
        Shrink::Folder.stub!(:find_by_name_and_parent_id).and_return(@found_folder)

        Shrink::Folder.find_or_create_by_name_and_parent!(@name, @parent).should eql(@found_folder)
      end

    end

    describe "when no folder is found" do

      it "should create a folder with the provided name and parent" do
        created_folder = mock("Folder::CreatedFolder")
        Shrink::Folder.stub!(:find_by_name_and_parent_id).and_return(nil)
        Shrink::Folder.stub!(:create!).with(:name => @name, :parent => @parent).and_return(created_folder)

        Shrink::Folder.find_or_create_by_name_and_parent!(@name, @parent).should eql(created_folder)
      end

    end

  end

  context "#valid?" do

    describe "when a project is established" do

      before(:each) do
        @folder.project = @project
      end

      describe "when a name is established" do

        describe "and the name is empty" do

          before(:each) do
            @folder.name = ""
          end

          it "should return false" do
            @folder.should_not be_valid
          end

        end

        describe "and the name is less than 256 character in length" do

          before(:each) do
            @folder.name = "a" * 255
          end

          it "should return true" do
            @folder.should be_valid
          end

        end

        describe "and the name is 256 character in length" do

          before(:each) do
            @folder.name = "a" * 256
          end

          it "should return true" do
            @folder.should be_valid
          end

        end

        describe "and the name is greater than 256 character in length" do

          before(:each) do
            @folder.name = "a" * 257
          end

          it "should return false" do
            @folder.should_not be_valid
          end

        end

        describe "and the name contains characters that are not alphanumeric, spaces, underscore or hyphens" do

          before(:each) do
            @folder.name = "Some Folder Name 1'"
          end

          it "should return false" do
            @folder.should_not be_valid
          end

        end

        describe "and the name contains only alphanumeric characters" do

          before(:each) do
            @folder.name = "SomeFolderName1"
          end

          it "should return true" do
            @folder.should be_valid
          end

        end

        describe "and the name contains alphanumeric characters and spaces" do

          before(:each) do
            @folder.name = "Some Folder Name 1"
          end

          it "should return true" do
            @folder.should be_valid
          end

        end

        describe "and the name contains alphanumeric characters and underscores" do

          before(:each) do
            @folder.name = "some_folder_name_1"
          end

          it "should return true" do
            @folder.should be_valid
          end

        end

        describe "and the name contains alphanumeric characters and hyphens" do

          before(:each) do
            @folder.name = "Some-Folder-Name-1"
          end

          it "should return true" do
            @folder.should be_valid
          end

        end

      end

      describe "when no name is established" do

        before(:each) do
          @folder.name = nil
        end

        it "should return false" do
          @folder.should_not be_valid
        end

      end

      describe "when no parent is established" do

        it "should be true" do
          @folder.should be_valid
        end

      end

      describe "when no children are established" do

        it "should return true" do
          @folder.should be_valid
        end

      end

    end

    describe "when no project is established" do

      before(:each) do
        @folder.project = nil
      end

      it "should return false" do
        @folder.should_not be_valid
      end

    end

  end

  context "#in_tree_path_until?" do

    before(:each) do
      @folder.parent = @project_root_folder
      @project_root_folder.stub!(:children).and_return([@folder])
      @children = (1..3).collect do |i|
        child = Shrink::Folder.new(:parent => @folder, :name => "Child Folder #{i}")
        child.stub!(:children).and_return([])
        child
      end
      @folder.stub!(:children).and_return(@children)
    end

    describe "when the folder is a parent of the parameterized folder" do

      it "should return true" do
        @folder.in_tree_path_until?(@children.second).should be_true
      end

    end

    describe "when the folder is a distant ancestor of the parameterized folder" do

      it "should return true" do
        @project_root_folder.in_tree_path_until?(@children.second).should be_true
      end

    end

    describe "when the folder is the same as the parameterized folder" do

      it "should return true" do
        @folder.in_tree_path_until?(@folder).should be_true
      end

    end

    describe "when the folder is a descendant of the parameterized folder" do

      it "should return false" do
        @folder.in_tree_path_until?(@project_root_folder).should be_false
      end

    end

  end

end
