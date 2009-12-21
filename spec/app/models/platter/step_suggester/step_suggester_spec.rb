describe Platter::StepSuggester::StepSuggester do

  context "#suggestions_for" do

    before(:each) do
      @context = mock("Context")
      Platter::StepSuggester::Context.stub!(:new).and_return(@context)
      Platter::StepSuggester::StepSuggester::SUGGESTER_CHAIN.each { |suggester| suggester.stub!(:suggestions_for) }
      @text = "Some Text"
      @position = 0
      @scenario = mock("Scenario")
    end

    it "should create a context from the provided text, position and scenario" do
      Platter::StepSuggester::Context.should_receive(:new).with(@text, @position, @scenario)

      suggestions
    end

    it "should execute all suggesters in the chain" do
      Platter::StepSuggester::StepSuggester::SUGGESTER_CHAIN.each do |suggester|
        suggester.should_receive(:suggestions_for).with(@context)
      end

      suggestions
    end

    it "should accumulate all suggester results" do
      expected_suggestions = Platter::StepSuggester::StepSuggester::SUGGESTER_CHAIN.collect_with_index do |suggester, i|
        suggestions = ["#{i}", "#{i}.1", "#{i}.2"]
        suggester.stub!(:suggestions_for).with(@context).and_return(suggestions)
        suggestions
      end.flatten

      suggestions.should eql(expected_suggestions)
    end

    def suggestions
      Platter::StepSuggester::StepSuggester.suggestions_for(@text, @position, @scenario)
    end


  end

end
