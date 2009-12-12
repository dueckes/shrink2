module Platter
  describe Package do

    before(:each) do
      @root_package = Package.new(:name => "Root Package")
      Package.stub!(:root).and_return(@root_package)
      @package = Package.new(:name => "Some Name")
    end

    it "should have a name" do
      @package.name.should eql("Some Name")
    end

    it "should have features" do
      features = (1..3).collect do |i|
        feature = Platter::Feature.new(:title => "Feature#{i}")
        @package.features << feature
        feature
      end

      @package.features.should eql(features)
    end

    it "should have a parent" do
      parent = Package.new(:name => "Parent Package Name")
      @package.parent = parent

      @package.parent.should eql(parent)
    end

    it "should have children" do
      children = (1..3).collect do |i|
        child = Package.new(:name => "Child #{i} Package Name")
        @package.children << child
        child
      end

      @package.children.should eql(children)
    end

    context "#tree_path" do

      describe "when the package is a child of the root node" do

        before(:each) do
          @package.parent = @root_package
        end

        it "should only return the package" do
          @package.tree_path.should eql([@package])
        end

      end

      describe "when the package is sibling two levels deep from the root node" do

        before(:each) do
          @root_descendant = Package.new(
                  :name => "Root Descendant Package Name", :parent => @root_package)
          @package.parent = @root_descendant
        end

        it "should return the siblings starting with the most mature" do
          @package.tree_path.should eql([@root_descendant, @package])
        end

      end

      describe "when the package is a sibling three levels deep from the root node" do

        before(:each) do
          @root_descendant = Package.new(
                  :name => "Root Descendant Package Name", :parent => @root_package)
          @inner_root_descendant = Package.new(
                  :name => "Inner Root Descendant Package Name", :parent => @root_descendant)
          @package.parent = @inner_root_descendant
        end

        it "should return the siblings starting with the most mature" do
          @package.tree_path.should eql([@root_descendant, @inner_root_descendant, @package])
        end

      end

    end

    context "#root_silbing?" do

      describe "when the package is a sibling of the root package" do

        before(:each) do
          @package.parent = @root_package
        end

        it "should return true" do
          @package.should be_root_sibling
        end

      end

      describe "when the package is a sibling of a sibling of the root package" do

        before(:each) do
          @package.parent = Package.new(:name => "Root Sibling Package", :parent => @root_package)
        end

        it "should return false" do
          @package.should_not be_root_sibling
        end

      end

    end

    context "#find_or_create!" do

      before(:each) do
        @root_package = mock("Package::Root")
        Package.stub!(:root).and_return(@root_package)
      end

      describe "when provided a package name" do

        before(:each) do
          @package_name = "some_package"
          @package = mock("Package")
        end

        it "should delegate to find_or_create_by_name_and_parent with the root package as parent" do
          Package.should_receive(:find_or_create_by_name_and_parent!).with(@package_name, @root_package).and_return(@package)

          Package.find_or_create!(@package_name).should eql(@package)
        end
  
      end

      describe "when provided with a path" do

        before(:each) do
          @package_names = %w(grandparent_package parent_package leaf_package)
          @package_name = @package_names.join("/")
          @packages = @package_names.each { |package_name| mock("Package::#{package_name}") }
          @grandparent_package, @parent_package, @leaf_package = *@packages
        end

        it "should delegate to find_or_create_by_name_and_parent! for each directory in the path with the direct ancestor as parent" do
          Package.should_receive(:find_or_create_by_name_and_parent!).with(@package_names.first, @root_package).and_return(@grandparent_package)
          Package.should_receive(:find_or_create_by_name_and_parent!).with(@package_names.second, @grandparent_package).and_return(@parent_package)
          Package.should_receive(:find_or_create_by_name_and_parent!).with(@package_names.third, @parent_package).and_return(@leaf_package)

          Package.find_or_create!(@package_name).should eql(@leaf_package)
        end

      end

    end

    context "#find_or_create_by_name_and_parent!" do

      before(:each) do
        @name = "Some Name"
        @parent = mock("Package::Parent", :id => 8)
      end

      describe "when a package is found" do

        before(:each) do
          @found_package = mock("Package")
        end

        it "should return the package" do
          Package.stub!(:find_by_name_and_parent_id).and_return(@found_package)

          Package.find_or_create_by_name_and_parent!(@name, @parent).should eql(@found_package)
        end

      end

      describe "when no package is found" do

        it "should create a package with the provided name and parent" do
          created_package = mock("Package::CreatedPackage")
          Package.stub!(:find_by_name_and_parent_id).and_return(nil)
          Package.stub!(:create!).with(:name => @name, :parent => @parent).and_return(created_package)

          Package.find_or_create_by_name_and_parent!(@name, @parent).should eql(created_package)
        end

      end

    end

    context "#valid?" do

      describe "when a name is established" do

        describe "and the name is empty" do

          before(:each) do
            @package.name = ""
          end

          it "should return false" do
            @package.should_not be_valid
          end

        end

        describe "and the name is less than 256 character in length" do

          before(:each) do
            @package.name = "a" * 255
          end

          it "should return true" do
            @package.should be_valid
          end

        end

        describe "and the name is 256 character in length" do

          before(:each) do
            @package.name = "a" * 256
          end

          it "should return true" do
            @package.should be_valid
          end

        end

        describe "and the name is greater than 256 character in length" do

          before(:each) do
            @package.name = "a" * 257
          end

          it "should return false" do
            @package.should_not be_valid
          end

        end

      end

      describe "when no name is established" do

        before(:each) do
          @package.name = nil
        end

        it "should return false" do
          @package.should_not be_valid
        end

      end

      describe "when no parent is established" do

        it "should be true" do
          @package.should be_valid
        end

      end

      describe "when no children are established" do

        it "should return true" do
          @package.should be_valid
        end

      end

    end

    context "#child_in_tree_path_until?" do

      before(:each) do
        @package.parent = @root_package
        @root_package.stub!(:children).and_return([@package])
        @children = (1..3).collect do |i|
          child = Package.new(:parent => @package, :name => "Child Package #{i}")
          child.stub!(:children).and_return([])
          child
        end
        @package.stub!(:children).and_return(@children)
      end

      describe "when the package has a child that is the parameterized package" do

        it "should return true" do
          @package.child_in_tree_path_until?(@children.second).should be_true
        end

      end

      describe "when the package has a child that is an ancestor of the parameterized package" do

        it "should return true" do
          @root_package.child_in_tree_path_until?(@children.first).should be_true
        end

      end

      describe "when the package has no children that is the same as or ancestors of the parameterized package" do

        it "should return false" do
          @package.child_in_tree_path_until?(@package).should be_false
        end

      end

      describe "when the package has no children" do

        it "should return false" do
          @children.first.child_in_tree_path_until?(@package).should be_false
        end

      end

    end
  end
end