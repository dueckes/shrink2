describe Shrink::Project do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    describe "when a project is created" do

      before(:all) do
        @project = Shrink::Project.create!(:name => "Test project")
      end

      it "should persist the project" do
        Shrink::Project.find_by_id(@project.id).should eql(@project)
      end

      it "should also create the projects root folder" do
        @project.root_folder.name.should eql("Root Folder")
        Shrink::Folder.find_by_id(@project.root_folder.id).should eql(@project.root_folder)
      end

      context "#valid?" do

        describe "on a new project with the same name" do

          before(:all) do
            @other_project = Shrink::Project.new(:name => "Test project")
          end

          it "should return false" do
            @other_project.should_not be_valid
          end

        end

        describe "on a new project with a different name" do

          before(:all) do
            @other_project = Shrink::Project.new(:name => "Other Test project")
          end

          it "should return true" do
            @other_project.should be_valid
          end
          
        end

      end

    end

    context "#folders.count" do

      before(:all) do
        @project = create_project!
      end

      describe "when no folders have been added" do

        it "should return 1 to account for the mandatory root folder" do
          @project.folders.count.should eql(1)
        end

      end

      describe "when multiple folders have been added" do

        before(:all) do
          (1..3).each { |i| create_folder!(:project => @project, :name => "Folder #{i}") }
        end

        it "should the number of folders added plus 1 to account for the root folder" do
          @project.folders.count.should eql(4)
        end

      end

    end

    context "#folders" do
      it_should_behave_like ClearDatabaseAfterEach

      before(:each) do
        @project = find_or_create_project!
      end

      describe "when folders have been added" do

        before(:each) do
          @folders = (1..3).collect do |i|
            Shrink::Folder.create!(:name => "Folder #{i}", :project => @project)
          end << @project.root_folder
          @project.folders(true)
        end

        it "should have the amount of folders added plus one to account for the root folder" do
          @project.folders.should have(4).folders
        end

        it "should all be destroyed when the project is destroyed" do
          @project.destroy

          @folders.each { |folder| Shrink::Folder.find_by_id(folder.id).should be_nil }
        end

      end

    end

    context "#project_users" do
      it_should_behave_like ClearDatabaseAfterEach

      before(:each) do
        @project = find_or_create_project!
      end

      describe "when folders have been added" do

        before(:each) do
          @project_users = (1..3).collect do |i|
            user = create_user!(:login => "Login #{i}")
            Shrink::ProjectUser.create!(:project => @project, :user => user)
          end
          @project.project_users(true)
        end

        it "should have the amount of project users added" do
          @project.project_users.should have(3).project_users
        end

        it "should all be destroyed when the project is destroyed" do
          @project.destroy

          @project_users.each { |project_user| Shrink::ProjectUser.find_by_id(project_user.id).should be_nil }
        end

      end

    end

    context "#users" do
      it_should_behave_like ClearDatabaseAfterEach

      before(:each) do
        @project = find_or_create_project!
      end

      describe "when users have been added" do

        before(:each) do
          @users = (1..3).collect do |i|
            user = create_user!(:login => "Login #{i}")
            @project.users << user
            user
          end
          @project.users(true)
        end

        it "should have the same amount of users that have been added" do
          @project.users.should have(3).users
        end

        it "should not be destroyed when the project is destroyed" do
          @project.destroy

          @users.each { |user| Shrink::User.find_by_id(user.id).should_not be_nil }
        end

      end

    end

  end

end
