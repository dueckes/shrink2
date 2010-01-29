describe Shrink::Role do

  it "should have a name" do
    role = Shrink::Role.new(:name => "Some Role Name")

    role.name.should eql("Some Role Name")
  end

  it "should have a description" do
    role = Shrink::Role.new(:description => "Some Role Description")

    role.description.should eql("Some Role Description")
  end

end
