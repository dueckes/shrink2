describe Shrink::ProjectUsers do
  
  describe "when mixed into a class" do

    class TestableProjectUsers
      include Shrink::ProjectUsers
  
      def initialize(project)
        @project = project
      end
      
      def proxy_owner
        @project
      end
      
    end
    
    describe "integrating with the database" do
      it_should_behave_like DatabaseIntegration
  
      context "#find_unassigned_with_normal_role_and_similar_login" do
        it_should_behave_like ClearDatabaseAfterAll
    
        before(:all) do
          @project = create_project!
          @project_users = TestableProjectUsers.new(@project)
    
          @normal_role = Shrink::Role.find_by_name("normal")
          @all_normal_users = (1..6).collect { |i| create_user!(:login => "User#{i}", :role => @normal_role) }
            
          @admin_user = create_user!(:login => "UserAdmin", :role => Shrink::Role.find_by_name("administrator"))
        end
    
        describe "when the login name provided matches the start of many user logins" do
    
          before(:all) do
            @login_provided = "User"
          end
    
          describe "and many users are not assigned to the project" do
    
            before(:all) do
              assign_users_to_project(@all_normal_users[0, 3])
    
              @found_users = find_unassigned_with_normal_role_and_similar_login
            end
    
            it "should not return administrators whose login name starts with the proivded login name" do
              @found_users.should_not include(@admin_user)
            end
    
            it "should return the normal users with matching logins not assigned to the project" do
              @found_users.should eql(@all_normal_users[3, 3])
            end
    
          end
    
          describe "and all users are assigned to the project" do
    
            before(:all) do
              assign_users_to_project(@all_normal_users)
    
              @found_users = find_unassigned_with_normal_role_and_similar_login
            end
    
            it "should return an empty array" do
              @found_users.should be_an_empty_array
            end
    
          end
    
        end
    
        describe "when the login name provided matches one user login" do
    
          before(:all) do
            @login_provided = "User1"
          end
    
          describe "and that user is not assigned to the project" do
    
            it "should return an array containing only the user" do
              find_unassigned_with_normal_role_and_similar_login.should eql([@all_normal_users.first])
            end
    
          end
    
          describe "and that user is assigned to the project" do
    
            before(:all) do
              assign_users_to_project([@all_normal_users.first])
    
              @found_users = find_unassigned_with_normal_role_and_similar_login
            end
    
            it "should return an empty array" do
              @found_users.should be_an_empty_array
            end
    
          end
    
        end
    
        describe "when the login name provided does not natch the start of any user logins" do
    
          before(:all) do
            @login_provided = "DoesNotMatch"
          end
    
          it "should return an empty array" do
            find_unassigned_with_normal_role_and_similar_login.should be_an_empty_array
          end
    
        end
    
        def assign_users_to_project(users)
          users.each { |user| Shrink::ProjectUser.create!(:project => @project, :user => user) }
          @project.users(true)
        end
    
        def find_unassigned_with_normal_role_and_similar_login
          @project_users.find_unassigned_with_normal_role_and_similar_login(@login_provided)
        end
    
      end
      
    end
    
  end

end
