describe Shrink::ProjectUsers do
  
  describe "when mixed into a class" do

    class TestableProjectUsers
      include Shrink::ProjectUsers

      attr_reader :proxy_association
  
      def initialize(project)
        @proxy_association = StubProxyAssociation.new(project)
      end
      
    end
    
    describe "integrating with the database" do
      include_context "database integration"
  
      context "#find_unassigned_with_normal_role_and_similar_login" do
        include_context "clear database after each"

        let!(:project) { create_project! }
        let!(:project_users) { TestableProjectUsers.new(project) }

        let(:normal_role) { Shrink::Role.find_by_name("normal") }
        let(:administrator_role) { Shrink::Role.find_by_name("administrator") }

        let!(:admin_user) { create_user!(:login => "UserAdmin", :role => Shrink::Role.find_by_name("administrator")) }
        let!(:all_normal_users) do
          (1..6).collect { |i| create_user!(:login => "User#{i}", :role => normal_role) }
        end

        let(:found_users) { project_users.find_unassigned_with_normal_role_and_similar_login(login_provided) }

        describe "when the login provided matches the start of many user logins" do

          let(:login_provided) { "User" }

          describe "and many users are not assigned to the project" do
    
            before(:each) { assign_users_to_project(all_normal_users[0, 3]) }

            it "should not return administrators whose login starts with the provided login" do
              found_users.should_not include(admin_user)
            end
    
            it "should return the normal users with matching logins not assigned to the project" do
              found_users.should eql(all_normal_users[3, 3])
            end
    
          end
    
          describe "and all users are assigned to the project" do

            before(:each) { assign_users_to_project(all_normal_users) }

            it "should return an empty array" do
              found_users.should be_an_empty_array
            end
    
          end
    
        end
    
        describe "when the login provided matches one user login" do
    
          let(:login_provided) { "User1" }

          describe "and that user is not assigned to the project" do
    
            it "should return an array containing only the user" do
              found_users.should eql([all_normal_users.first])
            end
    
          end
    
          describe "and that user is assigned to the project" do

            before(:each) { assign_users_to_project([all_normal_users.first]) }
    
            it "should return an empty array" do
              found_users.should be_an_empty_array
            end
    
          end
    
        end

        describe "when the login provided has different casing to the login of a user not assigned to the project" do

          let(:login_provided) { "uSER1" }

          it "should return an array containing the user" do
            found_users.should include(all_normal_users.first)
          end

        end
    
        describe "when the login provided does not natch the start of any user logins" do
    
          let(:login_provided) { "DoesNotMatch" }

          it "should return an empty array" do
            found_users.should be_an_empty_array
          end
    
        end
    
        def assign_users_to_project(users)
          users.each { |user| Shrink::ProjectUser.create!(:project => project, :user => user) }
          project.users(true)
        end
    
      end
      
    end
    
  end

end
