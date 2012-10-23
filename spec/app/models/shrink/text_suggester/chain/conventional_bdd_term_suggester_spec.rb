describe Shrink::TextSuggester::Chain::ConventionalBddTermSuggester do

  before(:each) do
    @configuration = mock("Configuration", :null_object => true)
    @context = mock("Context", :configuration => @configuration, :null_object => true)
  end

  context "#suggestions_for" do

    describe "when the text in the context contains a complete word" do

      before(:each) do
        @context.stub!(:text).and_return("Complete Word")
      end

      it "should return an empty array" do
        suggestions_for.should be_an_empty_array
      end

    end

    describe "when the text in the context contains an incomplete word" do

      before(:each) do
        @context.stub!(:text).and_return("IncompleteWord")
      end

      describe "and no next conventional bdd term suggestions are be found via the context" do

        before(:each) do
          @context.stub!(:find_next_conventional_bdd_term_suggestions).and_return(nil)
        end

        it "should return the first bdd term configured" do
          @configuration.stub!(:first_bdd_term).and_return("First Term")

          suggestions_for.should eql("First Term")
        end

      end

      describe "and next conventional bdd term suggestions are found via the context" do

        before(:each) do
          @suggestions = (1..3).collect { |i| "Suggestion#{i}" }
          @context.stub!(:find_next_conventional_bdd_term_suggestions).and_return(@suggestions)
        end

        it "should return the suggestions" do
          suggestions_for.should eql(@suggestions)
        end

      end

    end

    def suggestions_for
      Shrink::TextSuggester::Chain::ConventionalBddTermSuggester.suggestions_for(@context)
    end

  end

end
