describe Shrink::StepTextSuggester::ExistingStepTextSuggester do

  context "#suggestions_for" do

    before(:each) do
      @text = mock("String")
      @project_steps = mock("ProjectSteps")
      @project = mock("Project", :steps => @project_steps)
      @context = mock("Context", :text => @text, :project => @project,
                                 :number_of_suggestions_allowed => 88, :null_object => true)
    end

    describe "when the text is a complete word" do

      before(:each) do
        @text.stub!(:contains_complete_word?).and_return(true)
      end

      it "should return texts of all steps within the project containing similar text" do
        expected_texts = (1..3).collect { |i| "Step Text #{i}" }
        @project_steps.should_receive(:find_similar_texts).with(@text, anything).and_return(expected_texts)

        suggestions.should eql(expected_texts)
      end

      it "should limit the number of suggestions found to the number of suggestions allowed" do
        @project_steps.should_receive(:find_similar_texts).with(anything, 88)

        suggestions
      end

    end

    describe "when the text is an incomplete word" do

      before(:each) do
        @text.stub!(:contains_complete_word?).and_return(false)
      end

      it "should return an empty array" do
        suggestions.should be_empty
      end

    end

    def suggestions
      Shrink::StepTextSuggester::ExistingStepTextSuggester.suggestions_for(@context)
    end

  end

end
