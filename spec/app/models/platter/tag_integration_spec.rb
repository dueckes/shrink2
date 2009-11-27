module Platter
  describe Tag do

    describe "integrating with the database" do

      context "#valid?" do

        before(:each) do
          @tag = Tag.new(:name => "Some Name")
        end

        describe "when a name has been established" do

          describe "and no other tag has the same name" do

            it "should return true" do
              @tag.should be_valid
            end

          end

          describe "and another tag has the same name" do

            before(:each) do
              Tag.create!(:name => @tag.name)
            end

            it "should return false" do
              @tag.should_not be_valid
            end

          end

        end

      end

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
