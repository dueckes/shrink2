describe Platter::StepTextSuggester::Context do

  before(:each) do
    @text = "Some Text"
    @position = 8
    @scenario = mock("Scenario")
    @context = Platter::StepTextSuggester::Context.new(@text, @position, @scenario)
  end

  context "#text" do

    it "should return the text provided" do
      @context.text.should eql(@text)
    end

  end

  context "#texts_before" do

    it "should return the step texts until and excluding the position provided" do
      steps = (1..10).collect { |i| mock("Step", :text => "Step#{i}") }
      @scenario.stub!(:steps).and_return(steps)

      @context.texts_before.should eql(steps[0..7].collect(&:text))
    end

  end

  context "#suggestions" do

    describe "when no suggestions have been added" do

      it "should return an empty array" do
        @context.suggestions.should be_empty
      end

    end

    describe "when suggestions have been added" do

      before(:each) do
        @added_suggestions = create_suggestions(1..3)
        @context.add_suggestions(@added_suggestions)
      end

      it "should return the suggestions added" do
        @context.suggestions.should eql(@added_suggestions)
      end

    end

  end

  context "#add_suggestions" do

    describe "when suggestions have already been added" do

      before(:each) do
        @suggestions_already_added = create_suggestions(1..3)
        @context.add_suggestions(@suggestions_already_added)
      end

      it "should append an array of suggestions to the existing suggestions" do
        new_suggestions = create_suggestions(4..6)

        @context.add_suggestions(new_suggestions)

        @context.suggestions.should eql([@suggestions_already_added, new_suggestions].flatten)
      end

    end

    describe "when no suggestions have been previously added" do

      it "should establish the suggestions as those added" do
        new_suggestions = create_suggestions(1..3)

        @context.add_suggestions(new_suggestions)

        @context.suggestions.should eql(new_suggestions)
      end

    end

    describe "when more suggestions are being added than allowed" do

      before(:each) do
        @suggestions_added = create_suggestions(1..Platter::StepTextSuggester::Context::MAXIMUM_SUGGESTIONS + 1)
        @context.add_suggestions(@suggestions_added)
      end

      it "should limit the suggestions added to the number supported" do
        @context.suggestions.should eql(
                @suggestions_added[0..Platter::StepTextSuggester::Context::MAXIMUM_SUGGESTIONS - 1])
      end

    end

  end

  context "#number_of_suggestions_allowed" do

    describe "when no suggestions have been added" do

      it "should return the configured maximum" do
        @context.number_of_suggestions_allowed.should eql(Platter::StepTextSuggester::Context::MAXIMUM_SUGGESTIONS)
      end

    end

    describe "when suggestions have been added" do

      before(:each) do
        @context.add_suggestions(create_suggestions(1..3))
      end

      it "should return the configured maximum less the number of suggestions already added" do
        @context.number_of_suggestions_allowed.should eql(Platter::StepTextSuggester::Context::MAXIMUM_SUGGESTIONS - 3)
      end

    end

  end

  context "#more_suggestions_allowed" do

    describe "when the number of suggestions allowed has not been reached" do

      before(:each) do
        @context.stub(:number_of_suggestions_allowed).and_return(1)
      end

      it "should return true" do
        @context.more_suggestions_allowed?.should be_true
      end

    end

    describe "when the number of suggestions allowed has been reached" do

      before(:each) do
        @context.stub(:number_of_suggestions_allowed).and_return(0)
      end

      it "should return false" do
        @context.more_suggestions_allowed?.should be_false
      end

    end

  end

  def create_suggestions(range)
    range.collect { |i| "Suggestion #{i}" }
  end

end
