describe Shrink::Role do

  it "should have a name" do
    role = Shrink::Role.new(:name => "Some Role Name")

    role.name.should eql("Some Role Name")
  end

  it "should have a description" do
    role = Shrink::Role.new(:description => "Some Role Description")

    role.description.should eql("Some Role Description")
  end

  context "#administrator?" do

    describe "when the name of the role is administrator" do

      before(:each) do
        @role = Shrink::Role.new(:name => "administrator")
      end

      it "should return true" do
        @role.should be_an_administrator
      end

    end

    describe "when the name of the role is not administrator" do

      before(:each) do
        @role = Shrink::Role.new(:name => "not_administrator")
      end

      it "should return true" do
        @role.should_not be_an_administrator
      end

    end

  end

end
