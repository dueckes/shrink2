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
      
      describe "when a name has been established" do
        
        describe "whose length is less than 256 characters" do

          before(:each) do
            @tag.name = "a" * 255
          end

          it "should return true" do
            @tag.should be_valid
          end

        end

        describe "whose length is 256 characters" do

          before(:each) do
            @tag.name = "a" * 256
          end

          it "should return true" do
            @tag.should be_valid
          end

        end

        describe "whose length is greater than 256 characters" do

          before(:each) do
            @tag.name = "a" * 257
          end

          it "should return false" do
            @tag.should_not be_valid
          end

        end
        
        describe "that is empty" do

          before(:each) do
            @tag.name = ""
          end

          it "should return false" do
            @tag.should_not be_valid
          end

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

    end

    context "#summarize" do

      before(:each) do
        @tag = Tag.new(:name => "Some Name")
      end

      it "should return the name of the tag" do
        @tag.summarize.should eql("Some Name")
      end
      
    end

  end
end
