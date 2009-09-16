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
