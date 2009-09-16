describe Platter::Package do

  describe "integrating with the database" do

    before(:each) do
      @package = DatabaseModelFixture.create_package!
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
