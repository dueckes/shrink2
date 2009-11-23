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

      it "should return a package whose name is 'Root Package'" do
        @root_package.name.should eql("Root Package")
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

    context "#valid?" do

      before(:each) do
        @parent = DatabaseModelFixture.create_package!(:name => "Parent Package")
        @package.parent = @parent
        @package.name = "Package Name"
      end

      describe "when the name does not match the name of a package with the same parent" do

        before(:each) do
          DatabaseModelFixture.create_package!(:parent => @parent, :name => "Another Package Name")
        end

        it "should return true" do
          @package.should be_valid
        end

      end

      describe "when the name matches the name of another package with the same parent" do

        before(:each) do
          DatabaseModelFixture.create_package!(:parent => @parent, :name => "Package Name")
        end

        it "should return false" do
          @package.should_not be_valid
        end
        
      end

    end

  end

end
