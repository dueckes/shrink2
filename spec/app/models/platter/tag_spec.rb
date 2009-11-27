module Platter
  describe Tag do

    it "should have a name" do
      tag = Tag.new(:name => "Some Tag")

      tag.name.should eql("Some Tag")
    end

    it "should have features" do
      tag = Tag.new

      features = (1..3).collect do |i|
        feature = Feature.new(:title => "Title#{i}")
        tag.features << feature
        feature
      end

      tag.features.should eql(features)
    end

    context "#valid?" do

      before(:each) do
        @tag = Tag.new(:name => "Some Name")
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
