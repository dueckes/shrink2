describe Shrink::Folder do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration
    it_should_behave_like ClearDatabaseAfterEach      

    before(:each) do
      @project = Shrink::Project.create!(:name => "Project Name")
      @folder = Shrink::Folder.create!(:parent => @project.root_folder, :name => "Folder Name")
    end

    context "#parent" do

      it "should be assignable" do
        parent = create_folder!(:name => "Parent Name")

        @folder.parent = parent
        @folder.save!

        Shrink::Folder.find(@folder).parent.should eql(parent)
      end

    end

    context "#children" do

      before(:each) do
        @children = (1..3).collect do |i|
          child = create_folder!(:parent => @folder, :name => "Child #{i} Name")
          @folder.children << child
          child
        end
      end

      it "should be assignable" do
        Shrink::Folder.find(@folder).children.should eql(@children)
      end

      it "should be destroyed when their parent is destroyed" do
        @folder.destroy

        @children.each { |child| Shrink::Folder.find_by_id(child.id).should be_nil }
      end
      
    end

    context "#features" do

      describe "when features have been added" do

        before(:each) do
          @features = %w(c b a).collect do |character|
            Shrink::Feature.create!(:title => "Feature Title #{character}", :folder => @folder)
          end
          @folder.features(true)
        end

        it "should have the same amount of features that have been added" do
          @folder.features.should have(3).features
        end

        it "should be ordered by descending order of title" do
          expected_titles_in_order = %w(a b c).collect { |character| "Feature Title #{character}" }
          @folder.features.collect(&:title).should eql(expected_titles_in_order)
        end

        it "should all be destroyed when their folder is destroyed" do
          @folder.destroy

          @features.each { |feature| Shrink::Feature.find_by_id(feature.id).should be_nil }
        end

      end

    end

    context "#valid?" do

      before(:each) do
        @folder.name = "Folder Name"
      end

      describe "when a parent folder is established" do

        before(:each) do
          @parent = create_folder!(:name => "Parent Folder")
          @folder.parent = @parent
        end

        describe "when the name does not match the name of a folder with the same parent" do

          before(:each) do
            create_folder!(:parent => @parent, :name => "Another Folder Name")
          end

          it "should return true" do
            @folder.should be_valid
          end

        end

        describe "when the name matches the name of another folder with the same parent" do

          before(:each) do
            create_folder!(:parent => @parent, :name => "Folder Name")
          end

          it "should return false" do
            @folder.should_not be_valid
          end

        end

      end

      describe "when a parent folder is not established" do

        before(:each) do
          @folder.parent = nil
        end

        describe "when the name matches the name of another folder without a parent" do

          before(:each) do
            other_project = create_project!(:name => "Another Project Name")
            Shrink::Folder.create!(:project => other_project, :parent => nil, :name => "Folder Name")
          end

          it "should return true" do
            @folder.should be_valid
          end

        end

      end

    end

    context "#in_tree_path_until?" do

      describe "when the folder is an ancestor of the parameterized folder" do

        before(:each) do
          @child = create_folder!(:parent => @folder)
        end

        it "should return true" do
          @folder.in_tree_path_until?(@child).should be_true
        end

      end

    end

    context "#create_root_folder!" do

      before(:each) do
        @project = Shrink::Project.new(:name => "Some project name")
        @folder = Shrink::Folder.create_root_folder!(@project)
      end

      it "should persist a folder" do
        Shrink::Folder.find_by_id(@folder.id).should eql(@folder)
      end

      it "should create a root folder" do
        @folder.should be_root
      end

      it "should associate the project to the folder" do
        @project.root_folder.should eql(@folder)
      end

    end

  end

end
