describe Shrink::TextSuggester::Chain::SuggesterChain do

  before(:each) do
    @suggestions = mock("Suggestions", :null_object => true)
    @context = mock("Context", :suggestions => @suggestions, :null_object => true)

    suggesters.each { |suggester| suggester.stub!(:suggestions_for) }
  end

  context "#suggestions_for" do

    it "should retrieve suggestions for each suggester in the chain" do
      suggesters.each { |suggester| suggester.should_receive(:suggestions_for).with(@context) }

      suggestions_for
    end

    it "should accumulate the suggestions of each suggester via context" do
      suggesters.each_with_index do |suggester, i|
        suggestions = create_suggestions(i)
        suggester.stub!(:suggestions_for).with(@context).and_return(suggestions)
        @suggestions.should_receive(:add).with(suggestions)
      end

      suggestions_for
    end

    it "should not retrieve suggestions from a suggester when no more suggestions are allowed" do
      @suggestions.stub!(:more_allowed?).and_return(false)
      suggesters.each { |suggester| suggester.should_not_receive(:suggestions_for) }

      suggestions_for
    end

    it "should return an array representation of the contexts suggestions" do
      expected_suggestions = create_suggestions(1)
      @suggestions.stub(:to_a).and_return(expected_suggestions)

      suggestions_for.should eql(expected_suggestions)
    end

    def suggesters
      Shrink::TextSuggester::Chain::SuggesterChain::SUGGESTERS
    end

    def suggestions_for
      Shrink::TextSuggester::Chain::SuggesterChain.suggestions_for(@context)
    end

    def create_suggestions(unique_indicator)
      (1..3).collect { |i| "Suggestion#{unique_indicator}.#{i}" }
    end

  end

end
