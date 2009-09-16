describe Platter::Package do

  describe "integrating with the database" do

    before(:each) do
      @package = DatabaseModelFixture.create_package!
    end

    context "#root" do

      before(:all) do
        @root_package = Platter::Package.root
      end

      it "should return a package" do
        @root_package.should be_a_kind_of(Platter::Package)
      end

      it "should return a package whose parent is nil" do
        @root_package.parent.should be_nil
      end

      it "should return a package whose name is ROOT" do
        @root_package.name.should eql("ROOT")
      end

    end

    context "#parent" do

      it "should be assignable" do
        parent = DatabaseModelFixture.create_package!(:name => "Parent Name")

        @package.parent = parent
        @package.save!

        Platter::Package.find(@package).parent.should eql(parent)
      end

    end

    context "#children" do

      it "should be assignable" do
        children = (1..3).collect do |i|
          child = DatabaseModelFixture.create_package!(:name => "Child #{i} Name")
          @package.children << child
          child
        end
        
        Platter::Package.find(@package).children.should eql(children)
      end
      
    end

  end

end
