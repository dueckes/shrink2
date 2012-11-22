describe Shrink::Database do
  include_context "database integration"

  describe "#clear" do

    context "when an instance of each model is persisted" do

      before(:all) do
        @project = create_project!
        @feature = create_feature!(:project => @project)
        @scenario = create_scenario!(:feature => @feature)
        @tag = create_tag!(:project => @project)
        @user = create_user!
        @role = create_role!

        Shrink::Database.clear
      end

      it "should delete the persisted projects" do
        Shrink::Project.exists?(@project).should be_false
      end

      it "should delete the persisted features" do
        Shrink::Feature.exists?(@feature).should be_false
      end

      it "should delete the persisted feature constituents" do
        Shrink::Scenario.exists?(@scenario).should be_false
      end

      it "should delete the persisted tags" do
        Shrink::Tag.exists?(@tag).should be_false
      end

      it "should delete un-seeded users" do
        Shrink::User.exists?(@user).should be_false
      end

      it "should delete un-seeded roles" do
        Shrink::Role.exists?(@role).should be_false
      end

      it "should not clear seed data" do
        Shrink::User.all.map(&:login).should eql(%w{admin})
        Shrink::Role.all.map(&:name).should match_array(%w{administrator normal})
      end

    end

  end

end
