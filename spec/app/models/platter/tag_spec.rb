module Platter
  describe Tag do

    it "should have a name" do
      tag = Tag.new(:name => "Some Tag")

      tag.name.should eql("Some Tag")
    end

    context "#valid?" do

      before(:each) do
        @tag = Tag.new(:name => "Some Name")
      end

      describe "when a name has been established" do

        it "should return true" do
          @tag.should be_valid
        end

      end

      describe "when a name has not been established" do

        before(:each) do
          @tag.name = nil
        end

        it "should return false" do
          @tag.should_not be_valid
        end

      end

      describe "when the name is empty" do

        before(:each) do
          @tag.name = ""
        end

        it "should return false" do
          @tag.should_not be_valid
        end

      end

    end

  end
end
