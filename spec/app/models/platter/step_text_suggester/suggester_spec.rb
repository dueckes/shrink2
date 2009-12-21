describe Platter::StepTextSuggester::Suggester do

  context "#suggestions_for" do

    before(:each) do
      @context = mock("Context", :null_object => true)
      Platter::StepTextSuggester::Context.stub!(:new).and_return(@context)
      Platter::StepTextSuggester::Suggester::SUGGESTER_CHAIN.each { |suggester| suggester.stub!(:suggestions_for) }
      @text = "Some Text"
      @position = 0
      @scenario = mock("Scenario")
    end

    it "should create a context from the provided text, position and scenario" do
      Platter::StepTextSuggester::Context.should_receive(:new).with(@text, @position, @scenario)

      suggestions_for
    end

    describe "when the suggestion limit" do

      describe "is never reached" do

        it "should execute all suggesters in the chain" do
          Platter::StepTextSuggester::Suggester::SUGGESTER_CHAIN.each do |suggester|
            suggester.should_receive(:suggestions_for).with(@context)
          end

          suggestions_for
        end

      end

      describe "is reached" do

        it "should not execute suggesters after the suggester that reached the limit allowed" do
          @context.stub!(:more_suggestions_allowed?).and_return(true, false)
          first_suggester = Platter::StepTextSuggester::Suggester::SUGGESTER_CHAIN.first
          first_suggester.should_receive(:suggestions_for)

          other_suggesters = Platter::StepTextSuggester::Suggester::SUGGESTER_CHAIN[1..-1]
          other_suggesters.each { |suggester| suggester.should_not_receive(:suggestions_for) }

          suggestions_for
        end

      end

    end

    it "should add the suggestions offered by each suggester to the context" do
      Platter::StepTextSuggester::Suggester::SUGGESTER_CHAIN.each_with_index do |suggester, i|
        suggestions = create_suggestions(i)
        suggester.stub!(:suggestions_for).and_return(suggestions)
        @context.should_receive(:add_suggestions).with(suggestions)
      end

      suggestions_for
    end

    it "should return the suggestions added to context" do
      suggestions = ["Suggestions"]
      @context.should_receive(:suggestions).and_return(suggestions)

      suggestions_for.should eql(suggestions)
    end

    def suggestions_for
      Platter::StepTextSuggester::Suggester.suggestions_for(@text, @position, @scenario)
    end

    def create_suggestions(number_prefix)
      (0..2).collect { |j| "Suggestion #{number_prefix}.#{j}" }
    end

  end

end
