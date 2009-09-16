describe Platter::Package do

  before(:each) do
    @package = Platter::Package.new(:name => "Some Name")
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
    parent = Platter::Package.new(:name => "Parent Package Name")

    package = Platter::Package.new(:parent => parent)

    package.parent.should eql(parent)
  end

  it "should have children" do
    children = (1..3).collect do |i|
      child = Platter::Package.new(:name => "Child #{i} Package Name")
      @package.children << child
      child
    end

    @package.children.should eql(children)
  end

  context "#find_or_create!" do

    describe "when the package is a single directory" do

      before(:each) do
        @package_name = "some_package"
        @package = mock("Platter::Package")
      end

      it "should delegate to find_or_create_by_name_and_parent with a nil parent" do
        Platter::Package.should_receive(:find_or_create_by_name_and_parent!).with(@package_name, nil).and_return(@package)

        Platter::Package.find_or_create!(@package_name).should eql(@package)
      end

    end

    describe "when the package is nested" do

      before(:each) do
        @package_names = %w(root_package parent_package leaf_package)
        @package_name = @package_names.join("/")
        @packages = @package_names.each { |package_name| mock("Platter::Package::#{package_name}") }
        @root_package, @parent_package, @leaf_package = *@packages
      end

      it "should delegate to find_or_create_by_name_and_parent with a parent for each created ancestor" do
        Platter::Package.should_receive(:find_or_create_by_name_and_parent!).with(@package_names.first, nil).and_return(@root_package)
        Platter::Package.should_receive(:find_or_create_by_name_and_parent!).with(@package_names.second, @root_package).and_return(@parent_package)
        Platter::Package.should_receive(:find_or_create_by_name_and_parent!).with(@package_names.third, @parent_package).and_return(@leaf_package)

        Platter::Package.find_or_create!(@package_name).should eql(@leaf_package)
      end

    end

  end

  context "#find_or_create_by_name_and_parent!" do

    before(:each) do
      @name = "Some Name"
      @parent = mock("Platter::Package::Parent", :id => 8)
    end

    describe "when the parent is nil" do

      it "should find a package with a matching name and a nil parent_id" do
        Platter::Package.should_receive(:find_by_name_and_parent_id).with(@name, nil).and_return(mock("Platter::Package"))

        Platter::Package.find_or_create_by_name_and_parent!(@name, nil)
      end

    end

    describe "when the parent is not nil" do

      it "should find a package with a matching name and parent_id" do
        Platter::Package.should_receive(:find_by_name_and_parent_id).with(@name, 8).and_return(mock("Platter::Package"))

        Platter::Package.find_or_create_by_name_and_parent!(@name, @parent)
      end

    end

    describe "when a package is found" do

      before(:each) do
        @found_package = mock("Platter::Package")
      end

      it "should return the package" do
        Platter::Package.stub!(:find_by_name_and_parent_id).and_return(@found_package)

        Platter::Package.find_or_create_by_name_and_parent!(@name, @parent).should eql(@found_package)
      end

    end

    describe "when no package is found" do

      it "should create a package with the provided name and parent" do
        created_package = mock("Platter::Package::CreatedPackage")
        Platter::Package.stub!(:find_by_name_and_parent_id).and_return(nil)
        Platter::Package.stub!(:create!).with(:name => @name, :parent => @parent).and_return(created_package)

        Platter::Package.find_or_create_by_name_and_parent!(@name, @parent).should eql(created_package)
      end

    end

  end

  context "#valid?" do

    describe "when a name is established" do

      it "should return true" do
        @package.should be_valid
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

end
