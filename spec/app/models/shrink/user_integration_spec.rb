describe Shrink::User do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    describe "when a user is created" do

      before(:all) do
        @user = Shrink::User.create!(:login => "Some User Login", :password => "some_password",
                                     :password_confirmation => "some_password", :role => find_role!)
      end

      it "should persist the user" do
        Shrink::User.find_by_id(@user.id).should eql(@user)
      end

    end

    context "#user_projects" do
      it_should_behave_like ClearDatabaseAfterEach

      before(:each) do
        @user = create_user!
      end

      describe "when folders have been added" do

        before(:each) do
          @project_user = (1..3).collect do |i|
            project = create_project!(:name => "Project #{i}")
            Shrink::ProjectUser.create!(:project => project, :user => @user)
          end
          @user.user_projects(true)
        end

        it "should have the amount of user projects added" do
          @user.user_projects.should have(3).user_projects
        end

        it "should all be destroyed when the user is destroyed" do
          @user.destroy

          @project_user.each { |project_user| Shrink::ProjectUser.find_by_id(project_user.id).should be_nil }
        end

      end

    end

    context "#role" do

      describe "when a role has been established" do

        before(:all) do
          @role = find_role!
        end

        before(:each) do
          @user = create_user!(:role => @role)
        end

        it "should persist the users role" do
          Shrink::User.find(@user).role.should eql(@role)
        end

        it "should not be destroyed when the user is destroyed" do
          @user.destroy

          Shrink::Role.find_by_id(@role.id).should_not be_nil
        end

      end

    end

    context "#projects" do
      it_should_behave_like ClearDatabaseAfterEach

      before(:each) do
        @user = create_user!
      end

      describe "when projects have been added" do

        before(:each) do
          @projects = (1..3).collect do |i|
            project = create_project!(:name => "Project #{i}")
            @user.projects << project
            project
          end
          @user.projects(true)
        end

        it "should have the same amount of users that have been added" do
          @user.projects.should have(3).projects
        end

        it "should not be destroyed when the user is destroyed" do
          @user.destroy

          @projects.each { |project| Shrink::Project.find_by_id(project.id).should_not be_nil }
        end

      end

    end

    context "#valid?" do

      describe "when valid attributes are established including role_id as opposed to role" do

        before(:each) do
          @user = create_user!
          @user.role = nil
          @user.role_id = find_role!.id
        end

        it "should return true" do
          @user.should be_valid
        end

      end

    end

  end

end
