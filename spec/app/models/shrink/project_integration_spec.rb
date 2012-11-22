describe Shrink::Project do

  describe "integrating with the database" do
    include_context "database integration"

    describe "when a project is created" do
      include_context "clear database after all"

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
      include_context "clear database after each"

      before(:each) do
        @project = create_project!
      end

      describe "when no folders have been added" do

        it "should return 1 to account for the mandatory root folder" do
          @project.folders.count.should eql(1)
        end

      end

      describe "when multiple folders have been added" do

        before(:each) do
          (1..3).each { |i| create_folder!(:project => @project, :name => "Folder #{i}") }
        end

        it "should the number of folders added plus 1 to account for the root folder" do
          @project.folders.count.should eql(4)
        end

      end

    end

    context "#folders" do
      include_context "clear database after each"

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
          @project.should have(4).folders
        end

        it "should all be destroyed when the project is destroyed" do
          @project.destroy

          @folders.each { |folder| Shrink::Folder.find_by_id(folder.id).should be_nil }
        end

      end

    end

    context "#project_users" do
      include_context "clear database after each"

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
          @project.should have(3).project_users
        end

        it "should all be destroyed when the project is destroyed" do
          @project.destroy

          @project_users.each { |project_user| Shrink::ProjectUser.find_by_id(project_user.id).should be_nil }
        end

      end

    end

    context "#users" do
      include_context "clear database after each"

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
          @project.should have(3).users
        end

        it "should not be destroyed when the project is destroyed" do
          @project.destroy

          @users.each { |user| Shrink::User.find_by_id(user.id).should_not be_nil }
        end

      end

    end

    context "#tags" do
      include_context "clear database after each"

      before(:each) do
        @project = create_project!
        @project_tags = @project.tags
      end

      context "#find" do

        describe "when multiple projects contain multiple tags" do

          before(:each) do
            other_project = create_project!(:name => "Other Project")
            @tags_within_project = (1..3).collect do |i|
              create_tag!(:project => other_project, :name => "Tag #{i}")
              create_tag!(:project => @project, :name => "Tag #{i}")
            end
          end

          describe "and the conditions match multiple tags in multiple projects" do

            before(:each) do
              find_tags_ordered_by_name(:conditions => ["name like ?", "Tag %"])
            end

            it "should return the only the matching tags within the project" do
              @tags.should eql(@tags_within_project)
            end

          end

          describe "and the conditions match no tags within the project" do

            before(:each) do
              find_tags_ordered_by_name(:conditions => ["name = ?", "Does not match"])
            end

            it "should return an empty array" do
              @tags.should be_empty
            end

          end

        end

        describe "when a project contains no tags" do

          it "should return an empty array" do
            @project_tags.all.should be_empty
          end

        end

        def find_tags_ordered_by_name(options)
          @tags = @project_tags.all({ :order => "name asc" }.merge(options))
        end

      end

      context "#count" do

        describe "when the project contains multiple tags" do

          before(:each) do
            (1..3).each { |i| create_tag!(:project => @project, :name => "Tag #{i}") }
          end

          it "should return the number of tags within the project" do
            @project_tags.count.should eql(3)
          end

        end

        describe "when the project contains no tags" do

          it "should return 0" do
            @project_tags.count.should eql(0)
          end

        end

      end

    end

    context "#default" do
      include_context "clear database after each"

      describe "when no projects have been added" do

        it "should return a persisted project" do
          project = Shrink::Project.default

          project.should be_a(Shrink::Project)
          project.should_not be_a_new_record
        end

        it "should return a project whose name indicates it has been auto-generated" do
          project = Shrink::Project.default

          project.name.should match(/auto-generated/i) 
        end

      end

      describe "when one project has been added" do

        before(:each) do
          @project = create_project!
        end

        it "should return the project" do
          Shrink::Project.default.should eql(@project)
        end

      end

      describe "when more than one project has been added" do

        before(:each) do
          2.times { create_project! }
        end

        it "should raise an error indicating more than one project exists" do
          lambda { Shrink::Project.default }.should raise_error(Exception, /more than one project exists/i)
        end

      end
      
    end

  end

end
