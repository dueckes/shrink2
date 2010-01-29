describe Shrink::StepTextSuggester::Context do

  before(:each) do
    @text = "Some Text"
    @position = 8
    @steps = (1..10).collect { |i| mock("Step", :text => "Step#{i}") }
    @scenario = mock("Scenario", :steps => @steps)
    @context = Shrink::StepTextSuggester::Context.new(@text, @position, @scenario)
  end

  context "#text" do

    it "should return the text provided" do
      @context.text.should eql(@text)
    end

  end

  context "#project" do

    before(:each) do
      @project = mock("Project")
      @scenario.stub!(:feature).and_return(mock("Feature", :project => @project))
    end

    it "should retrieve the project associated with the scenarios feature" do
      @context.project.should eql(@project)
    end

  end

  context "#texts_before" do

    describe "when there are steps before the position" do

      it "should return the step texts before the position provided" do
        @context.texts_before.should eql(@steps[0..7].collect(&:text))
      end

    end

    describe "when the position is at the start" do

      before(:each) do
        @context = Shrink::StepTextSuggester::Context.new(@text, 0, @scenario)
      end

      it "should return an empty array" do
        @context.texts_before.should be_empty
      end

    end

    describe "when a step contains a table that is before the position" do

      before(:each) do
        step_with_table = mock("Step", :text => nil, :table => mock("Table"))
        @steps = @steps[0..2] + [step_with_table] + @steps[3..-1]
        @scenario.stub!(:steps).and_return(@steps)
      end

      it "should not include a nil element" do
        @context.texts_before.should_not include(nil)
      end

      it "should include all steps having text before the position" do
        @context.texts_before.should eql((@steps[0..2] + @steps[4..7]).collect(&:text))
      end

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
        @suggestions_added = create_suggestions(1..Shrink::StepTextSuggester::Context::MAXIMUM_SUGGESTIONS + 1)
        @context.add_suggestions(@suggestions_added)
      end

      it "should limit the suggestions added to the number supported" do
        @context.suggestions.should eql(
                @suggestions_added[0..Shrink::StepTextSuggester::Context::MAXIMUM_SUGGESTIONS - 1])
      end

    end

  end

  context "#number_of_suggestions_allowed" do

    describe "when no suggestions have been added" do

      it "should return the configured maximum" do
        @context.number_of_suggestions_allowed.should eql(Shrink::StepTextSuggester::Context::MAXIMUM_SUGGESTIONS)
      end

    end

    describe "when suggestions have been added" do

      before(:each) do
        @context.add_suggestions(create_suggestions(1..3))
      end

      it "should return the configured maximum less the number of suggestions already added" do
        @context.number_of_suggestions_allowed.should eql(Shrink::StepTextSuggester::Context::MAXIMUM_SUGGESTIONS - 3)
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
