describe Platter::StepTextSuggester::ExistingStepTextSuggester do

  describe "integrating with the database" do

    #TODO Strip text filter does not apply to auto-complete
    context "#suggestions_for" do

      before(:all) do
        create_scenarios
        create_steps("First word in a phrase",
                     "Firstly the outcome was inevitable",
                     "Some phrase that does not start with First",
                     "First second in this minute",
                     "First sec on this day",
                     "Some phrase that does not start with First second", 
                     "First second third - it was incrementing in single digits",
                     "First second third the number of clients connecting was increasing",
                     "Some phrase that does not start with First second third")
      end

      after(:all) do
        # TODO Transactional specs not configured
        Platter::Feature.destroy_all
      end

      before(:each) do
        @context = mock("Context", :number_of_suggestions_allowed => 10)
      end

      describe "when no text is provided" do

        before(:each) do
          @context.stub!(:text).and_return("")
        end

        it "should return no suggestions" do
          suggestions.should be_empty
        end

      end

      describe "when the text contains an incomplete word" do

        before(:each) do
          @context.stub!(:text).and_return("First")
        end

        it "should return no suggestions" do
          suggestions.should be_empty
        end

      end

      describe "when the text contains a complete word" do

        before(:each) do
          @context.stub!(:text).and_return("First ")
          @expected_results = ["First word in a phrase",
                               "First second in this minute",
                               "First sec on this day",
                               "First second third - it was incrementing in single digits",
                               "First second third the number of clients connecting was increasing"].sort
        end

        describe "and the number of candidate results is within the number of additional suggestions allowed" do

          it "should retrieve existing step texts that starts with the word" do
            suggestions.sort.should eql(@expected_results)
          end

        end

        describe "and the number of candidate results exceeds the number of additional suggestions allowed" do

          before(:each) do
            @context.stub!(:number_of_suggestions_allowed).and_return(3)
          end

          it "should return results whose size is limited to the number of suggestions allowed" do
            suggestions.should eql(@expected_results[0..2])
          end

        end

        it "should retrieve step texts in alphabetical order" do
          retrieved_suggestions = suggestions
          retrieved_suggestions.sort.should eql(retrieved_suggestions)
        end

      end

      describe "when the text contains a word and an incomplete word" do

        before(:each) do
          @context.stub!(:text).and_return("First sec")
        end

        it "should retrieve existing step texts that starts with the word and the incomplete word" do
          suggestions.sort.should eql(["First second in this minute", "First sec on this day",
                                       "First second third - it was incrementing in single digits",
                                       "First second third the number of clients connecting was increasing"].sort)
        end

      end

      describe "when the text contains multiple words" do

        before(:all) do
          @expected_suggestions = ["First second third - it was incrementing in single digits",
                                   "First second third the number of clients connecting was increasing"]
        end

        describe "in the same casing as existing step texts" do

          before(:each) do
            @context.stub!(:text).and_return("First second third")
          end

          it "should retrieve existing step texts that starts with the words" do
            suggestions.sort.should eql(@expected_suggestions.sort)
          end

        end

        describe "with casing different than existing step texts" do

          before(:each) do
            @context.stub!(:text).and_return("fIRST SECOND tHiRd")
          end

          it "should ignore the casing and retrieve existing step texts that starts with the words" do
            suggestions.sort.should eql(@expected_suggestions.sort)
          end

        end

      end

      def create_steps(*texts)
        texts.each_with_index { |text, i| Platter::Step.create!(:text => text, :scenario => @scenarios[i % 3]) }
      end

      def create_scenarios
        @scenarios = (1..3).collect do |i|
          feature = DatabaseModelFixture.create_feature!(:title => "Feature #{i}")
          DatabaseModelFixture.create_scenario!(:feature => feature, :title => "Scenario #{i}")
        end
      end

      def suggestions
        Platter::StepTextSuggester::ExistingStepTextSuggester.suggestions_for(@context)
      end

    end

  end

end
