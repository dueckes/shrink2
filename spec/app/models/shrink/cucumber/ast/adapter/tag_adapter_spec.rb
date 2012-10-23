describe Shrink::Cucumber::Ast::Adapter::TagAdapter do

  context "#adapt" do

    describe "when a raw tag name is provided" do

      before(:each) do
        @raw_tag_name = "@some_tag"
      end

      it "should return a tag whose name is the raw tag name with the prefixed '@' omitted" do
        to_tag

        @tag.should be_a(Shrink::Tag)
        @tag.name.should eql("some_tag")
      end

    end

    def to_tag
      @tag = Shrink::Cucumber::Ast::Adapter::TagAdapter.adapt(@raw_tag_name)
    end

  end

end
