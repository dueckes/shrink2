describe Shrink::ProjectUser do

  it "should belong to a project" do
    project = Shrink::Project.new(:name => "Some Project")

    project_user = Shrink::ProjectUser.new(:project => project)

    project_user.project.should eql(project)
  end

  it "should belong to a user" do
    user = Shrink::User.new(:login => "Some User")

    project_user = Shrink::ProjectUser.new(:user => user)

    project_user.user.should eql(user)
  end

end
