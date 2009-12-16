describe Platter::Folder do

  describe "integrating with the database" do

    before(:each) do
      @folder = DatabaseModelFixture.create_folder!
    end

    context "#root" do

      before(:all) do
        @root_folder = Platter::Folder.root
      end

      it "should return a folder" do
        @root_folder.should be_a_kind_of(Platter::Folder)
      end

      it "should return a folder whose parent is nil" do
        @root_folder.parent.should be_nil
      end

      it "should return a folder whose name is 'Root Folder'" do
        @root_folder.name.should eql("Root Folder")
      end

    end

    context "#parent" do

      it "should be assignable" do
        parent = DatabaseModelFixture.create_folder!(:name => "Parent Name")

        @folder.parent = parent
        @folder.save!

        Platter::Folder.find(@folder).parent.should eql(parent)
      end

    end

    context "#children" do

      before(:each) do
        @children = (1..3).collect do |i|
          child = DatabaseModelFixture.create_folder!(:name => "Child #{i} Name")
          @folder.children << child
          child
        end
      end

      it "should be assignable" do
        Platter::Folder.find(@folder).children.should eql(@children)
      end

      it "should be destroyed when their parent is destroyed" do
        @folder.destroy

        @children.each { |child| Platter::Folder.find_by_id(child.id).should be_nil }
      end
      
    end

    context "#features" do

      describe "when features have been added" do

        before(:each) do
          @features = %w(c b a).collect do |character|
            Platter::Feature.create!(:title => "Feature Title #{character}", :folder => @folder)
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

          @features.each { |feature| Platter::Feature.find_by_id(feature.id).should be_nil }
        end

      end

    end

    context "#valid?" do

      before(:each) do
        @parent = DatabaseModelFixture.create_folder!(:name => "Parent Folder")
        @folder.parent = @parent
        @folder.name = "Folder Name"
      end

      describe "when the name does not match the name of a folder with the same parent" do

        before(:each) do
          DatabaseModelFixture.create_folder!(:parent => @parent, :name => "Another Folder Name")
        end

        it "should return true" do
          @folder.should be_valid
        end

      end

      describe "when the name matches the name of another folder with the same parent" do

        before(:each) do
          DatabaseModelFixture.create_folder!(:parent => @parent, :name => "Folder Name")
        end

        it "should return false" do
          @folder.should_not be_valid
        end
        
      end

    end

    context "#in_tree_path_until?" do

      describe "when the folder is an ancestor of the parameterized folder" do

        before(:each) do
          @child = DatabaseModelFixture.create_folder!(:parent => @folder)
        end

        it "should return true" do
          @folder.in_tree_path_until?(@child).should be_true
        end

      end

    end

  end

end
