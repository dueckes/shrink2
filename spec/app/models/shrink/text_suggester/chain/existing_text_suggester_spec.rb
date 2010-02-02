describe Shrink::TextSuggester::Chain::ExistingTextSuggester do

  before(:each) do
    @context = mock("Context", :null_object => true)
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
        suggestions = suggestions_for

        suggestions.should be_an(Array)
        suggestions.should be_empty
      end

    end

    def suggestions_for
      Shrink::TextSuggester::Chain::ExistingTextSuggester.suggestions_for(@context)
    end

  end

end
