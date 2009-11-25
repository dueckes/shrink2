module Platter
  describe Tag do

    describe "integrating with the database" do

      context "#find_or_create!" do

        describe "when a tag with the same name" do

          describe "already exists" do

            before(:each) do
              @tag = Tag.create!(:name => "Some Name")
            end

            it "should return the existing tag" do
              Tag.find_or_create!(:name => @tag.name).should == @tag
            end

          end

          describe "does not already exist" do

            before(:each) do
              @tag = Tag.find_or_create!(:name => "Some Name")
            end

            it "should return a persisted tag with the same name" do
              @tag.should_not be_a_new_record
              @tag.name.should eql("Some Name")
            end

          end

        end

      end

    end

  end
end
