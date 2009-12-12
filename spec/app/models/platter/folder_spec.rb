module Platter
  describe Folder do

    before(:each) do
      @root_folder = Folder.new(:name => "Root Folder")
      Folder.stub!(:root).and_return(@root_folder)
      @folder = Folder.new(:name => "Some Name")
    end

    it "should have a name" do
      @folder.name.should eql("Some Name")
    end

    it "should have features" do
      features = (1..3).collect do |i|
        feature = Platter::Feature.new(:title => "Feature#{i}")
        @folder.features << feature
        feature
      end

      @folder.features.should eql(features)
    end

    it "should have a parent" do
      parent = Folder.new(:name => "Parent Folder Name")
      @folder.parent = parent

      @folder.parent.should eql(parent)
    end

    it "should have children" do
      children = (1..3).collect do |i|
        child = Folder.new(:name => "Child #{i} Folder Name")
        @folder.children << child
        child
      end

      @folder.children.should eql(children)
    end

    context "#tree_path" do

      describe "when the folder is a child of the root node" do

        before(:each) do
          @folder.parent = @root_folder
        end

        it "should only return the folder" do
          @folder.tree_path.should eql([@folder])
        end

      end

      describe "when the folder is sibling two levels deep from the root node" do

        before(:each) do
          @root_descendant = Folder.new(
                  :name => "Root Descendant Folder Name", :parent => @root_folder)
          @folder.parent = @root_descendant
        end

        it "should return the siblings starting with the most mature" do
          @folder.tree_path.should eql([@root_descendant, @folder])
        end

      end

      describe "when the folder is a sibling three levels deep from the root node" do

        before(:each) do
          @root_descendant = Folder.new(
                  :name => "Root Descendant Folder Name", :parent => @root_folder)
          @inner_root_descendant = Folder.new(
                  :name => "Inner Root Descendant Folder Name", :parent => @root_descendant)
          @folder.parent = @inner_root_descendant
        end

        it "should return the siblings starting with the most mature" do
          @folder.tree_path.should eql([@root_descendant, @inner_root_descendant, @folder])
        end

      end

    end

    context "#root_silbing?" do

      describe "when the folder is a sibling of the root folder" do

        before(:each) do
          @folder.parent = @root_folder
        end

        it "should return true" do
          @folder.should be_root_sibling
        end

      end

      describe "when the folder is a sibling of a sibling of the root folder" do

        before(:each) do
          @folder.parent = Folder.new(:name => "Root Sibling Folder", :parent => @root_folder)
        end

        it "should return false" do
          @folder.should_not be_root_sibling
        end

      end

    end

    context "#find_or_create!" do

      before(:each) do
        @root_folder = mock("Folder::Root")
        Folder.stub!(:root).and_return(@root_folder)
      end

      describe "when provided a folder name" do

        before(:each) do
          @folder_name = "some_folder"
          @folder = mock("Folder")
        end

        it "should delegate to find_or_create_by_name_and_parent with the root folder as parent" do
          Folder.should_receive(:find_or_create_by_name_and_parent!).with(@folder_name, @root_folder).and_return(@folder)

          Folder.find_or_create!(@folder_name).should eql(@folder)
        end
  
      end

      describe "when provided with a path" do

        before(:each) do
          @folder_names = %w(grand_parent_folder parent_folder leaf_folder)
          @folder_name = @folder_names.join("/")
          @folders = @folder_names.each { |folder_name| mock("Folder::#{folder_name}") }
          @grand_parent_folder, @parent_folder, @leaf_folder = *@folders
        end

        it "should delegate to find_or_create_by_name_and_parent! for each directory in the path with the direct ancestor as parent" do
          Folder.should_receive(:find_or_create_by_name_and_parent!).with(@folder_names.first, @root_folder).and_return(@grand_parent_folder)
          Folder.should_receive(:find_or_create_by_name_and_parent!).with(@folder_names.second, @grand_parent_folder).and_return(@parent_folder)
          Folder.should_receive(:find_or_create_by_name_and_parent!).with(@folder_names.third, @parent_folder).and_return(@leaf_folder)

          Folder.find_or_create!(@folder_name).should eql(@leaf_folder)
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
          Folder.stub!(:find_by_name_and_parent_id).and_return(@found_folder)

          Folder.find_or_create_by_name_and_parent!(@name, @parent).should eql(@found_folder)
        end

      end

      describe "when no folder is found" do

        it "should create a folder with the provided name and parent" do
          created_folder = mock("Folder::CreatedFolder")
          Folder.stub!(:find_by_name_and_parent_id).and_return(nil)
          Folder.stub!(:create!).with(:name => @name, :parent => @parent).and_return(created_folder)

          Folder.find_or_create_by_name_and_parent!(@name, @parent).should eql(created_folder)
        end

      end

    end

    context "#valid?" do

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

    context "#child_in_tree_path_until?" do

      before(:each) do
        @folder.parent = @root_folder
        @root_folder.stub!(:children).and_return([@folder])
        @children = (1..3).collect do |i|
          child = Folder.new(:parent => @folder, :name => "Child Folder #{i}")
          child.stub!(:children).and_return([])
          child
        end
        @folder.stub!(:children).and_return(@children)
      end

      describe "when the folder has a child that is the parameterized folder" do

        it "should return true" do
          @folder.child_in_tree_path_until?(@children.second).should be_true
        end

      end

      describe "when the folder has a child that is an ancestor of the parameterized folder" do

        it "should return true" do
          @root_folder.child_in_tree_path_until?(@children.first).should be_true
        end

      end

      describe "when the folder has no children that is the same as or ancestors of the parameterized folder" do

        it "should return false" do
          @folder.child_in_tree_path_until?(@folder).should be_false
        end

      end

      describe "when the folder has no children" do

        it "should return false" do
          @children.first.child_in_tree_path_until?(@folder).should be_false
        end

      end

    end
  end
end