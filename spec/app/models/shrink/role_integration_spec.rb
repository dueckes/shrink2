describe Shrink::Role do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    describe "when one role is created" do

      before(:all) do
        @role = Shrink::Role.create!(:name => "Some Role Name", :description => "Some Role Description")
      end

      it "should persist the role" do
        Shrink::Role.find_by_id(@role.id).should eql(@role)
      end

    end

  end

end
