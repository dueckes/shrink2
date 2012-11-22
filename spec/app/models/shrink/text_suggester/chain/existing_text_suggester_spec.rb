describe Shrink::TextSuggester::Chain::ExistingTextSuggester do

  before(:each) do
    @context = mock("Context").as_null_object
  end

  context "#suggestions_for" do

    describe "when the text in the context contains a complete word" do

      before(:each) do
        @context.stub!(:text).and_return("Complete Word")
      end

      it "should return similar existing texts via the context" do
        found_texts = (1..3).collect { |i| "Text#{i}" }
        @context.should_receive(:find_similar_existing_texts).and_return(found_texts)

        suggestions_for.should eql(found_texts)
      end

    end

    describe "when the text in the context contains an incomplete word" do

      before(:each) do
        @context.stub!(:text).and_return("IncompleteWord")
      end

      it "should return an empty array" do
        suggestions_for.should be_an_empty_array
      end

    end

    def suggestions_for
      Shrink::TextSuggester::Chain::ExistingTextSuggester.suggestions_for(@context)
    end

  end

end
