describe Shrink::User do

  before(:each) do
    @user = Shrink::User.new
  end

  it "should have a role" do
    role = Shrink::Role.new(:name => "some_role_name")

    @user.role = role

    @user.role.should eql(role)
  end

  it "should have projects" do
    projects = (1..3).collect do |i|
      project = Shrink::Project.new(:name => "Project #{i}")
      @user.projects << project
      project
    end

    @user.projects.should eql(projects)
  end

  context "#valid?" do

    before(:each) do
      @user = Shrink::User.new
    end

    describe "when a login has been provided" do

      before(:each) do
        @user.login = "some_login"
      end
                                                                                
      describe "and a password has been provided" do

        before(:each) do
          @user.password = "some_password"
        end

        describe "and a password confirmation matching the password has been provided" do

          before(:each) do
            @user.password_confirmation = @user.password
          end

          describe "and a role has been provided" do

            before(:each) do
              @user.role = new_role
            end

            it "should return true" do
              @user.should be_valid
            end

          end

        end

      end

    end

    describe "when the user has valid attributes established" do

      before(:each) do
        @user.attributes = { :login => "some_login", :password => "some_password",
                             :password_confirmation => "some_password", :role => new_role }
      end

      describe "and the login is removed" do

        before(:each) do
          @user.login = nil
        end

        it "should return false" do
          @user.should_not be_valid
        end

      end

      describe "and the password is removed" do

        before(:each) do
          @user.password = nil
        end

        it "should return false" do
          @user.should_not be_valid
        end

      end

      describe "and the password confirmation is removed" do

        before(:each) do
          @user.password_confirmation = nil
        end

        it "should return false" do
          @user.should_not be_valid
        end

      end

      describe "and the password confirmation is changed so that it does not match the password" do

        before(:each) do
          @user.password_confirmation = "does not match password"
        end

        it "should return false" do
          @user.should_not be_valid
        end

      end

      describe "and the role is removed" do

        before(:each) do
          @user.role = nil
        end

        it "should return false" do
          @user.should_not be_valid
        end

      end

    end

  end

  context "#administrator?" do

    before(:each) do
      @role = @user.role = new_role
    end

    describe "when the user has an administrator role" do

      before(:each) do
        @role.stub!(:administrator?).and_return(true)
      end

      it "should return true" do
        @user.should be_an_administrator
      end

    end

    describe "when the user does not have an administrator role" do

      before(:each) do
        @role.stub!(:administrator?).and_return(false)
      end

      it "should return true" do
        @user.should_not be_an_administrator 
      end

    end

  end

  context "#demotion" do

    before(:each) do
      @proposed_role = new_role(:name => "proposed_role_name")

      @user.role = new_role(:name => "current_role_name")
    end

    describe "when the users has an administrator role" do

      before(:each) do
        @user.role.stub!(:administrator?).and_return(true)
      end

      describe "and the proposed role is normal" do

        before(:each) do
          @proposed_role.stub!(:administrator?).and_return(false)
        end

        it "should return true" do
          @user.demotion?(@proposed_role).should be_true
        end

      end

      describe "and the proposed role is administrator" do

        before(:each) do
          @proposed_role.stub!(:administrator?).and_return(true)
        end

        it "should return false" do
          @user.demotion?(@proposed_role).should be_false
        end

      end

    end

    describe "when the user has a normal role" do

      before(:each) do
        @user.role.stub!(:administrator?).and_return(false)
      end

      describe "and the proposed role is administrator" do

        before(:each) do
          @proposed_role.stub!(:administrator?).and_return(true)
        end

        it "should return false" do
          @user.demotion?(@proposed_role).should be_false
        end

      end

      describe "and the proposed role is normal" do

        before(:each) do
          @proposed_role.stub!(:administrator?).and_return(false)
        end

        it "should return false" do
          @user.demotion?(@proposed_role).should be_false
        end

      end

    end

  end

  context "#role_symbols" do

    before(:each) do
      @user.role = new_role("some_role_name")
    end

    it "should return an array containing a symbolized version of users name" do
      @user.role_symbols.should eql([:some_role_name])
    end

  end

  def new_role(name="role_name")
    Shrink::Role.new(:name => name, :description => "Role Description")
  end

end
