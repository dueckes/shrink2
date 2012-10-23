describe Shrink::TextSuggester::Base do

  describe "when it is extended and configured" do

    class TestableTextSuggesterBase < Shrink::TextSuggester::Base
      set_model_name :some_model_name
      set_conventional_bdd_suggestion_rules "FirstTerm", [ ["Rule", [ "SecondTerm" ] ] ]
    end

    context "#suggestions_for" do

      before(:each) do
        @parent_model = mock("ParentModel")
        Shrink::TextSuggester::Chain::SuggesterChain.stub!(:suggestions_for)
      end

      it "should create a configuration with the configured values" do
        Shrink::TextSuggester::Context::Configuration.should_receive(:new).with(
                :some_model_name, ["FirstTerm", [ ["Rule", [ "SecondTerm" ] ] ] ])

        suggestions_for
      end

      it "should create a context with the provided arguments and configuration" do
        configuration = mock("Configuration")
        Shrink::TextSuggester::Context::Configuration.stub!(:new).and_return(configuration)

        Shrink::TextSuggester::Context::Context.should_receive(:new).with(configuration, "Some Text", 8, @parent_model)

        suggestions_for
      end

      it "should execute the suggester chain with the context" do
        context = mock("Context")
        Shrink::TextSuggester::Context::Context.stub!(:new).and_return(context)

        Shrink::TextSuggester::Chain::SuggesterChain.should_receive(:suggestions_for).with(context)

        suggestions_for
      end

      it "should return the suggester chain execution result" do
        expected_suggestions = (1..3).collect { |i| "Suggestion#{i}" }
        Shrink::TextSuggester::Chain::SuggesterChain.stub!(:suggestions_for).and_return(expected_suggestions)

        suggestions_for.should eql(expected_suggestions)
      end

      def suggestions_for
        TestableTextSuggesterBase.suggestions_for("Some Text", 8, @parent_model)
      end

    end

  end

end
