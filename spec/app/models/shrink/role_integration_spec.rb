describe Shrink::Role do

  describe "integrating with the database" do
    include_context "database integration"

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
