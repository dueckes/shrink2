describe Shrink::TextSuggester::Context::Configuration do

  before(:each) do
    bdd_suggestion_rules = [ "FirstSuggestion",
                             [ "FirstRule", [ "SecondSuggestion" ] ],
                             [ "SecondRule", [ "ThirdSuggestion" ] ],
                             [ "ThirdRule", [ "FourthSuggestion" ] ] ]
    @configuration = Shrink::TextSuggester::Context::Configuration.new(:some_model_name, bdd_suggestion_rules)
  end

  context "#first_bdd_term" do

    it "should return the first element in the provided rules" do
      @configuration.first_bdd_term.should eql("FirstSuggestion")
    end

  end

  context "#bdd_term_rules" do

    it "should return all elements other than the first in the provided rules" do
      @configuration.bdd_term_rules.should eql(
              [ [ "FirstRule", [ "SecondSuggestion" ] ],
                [ "SecondRule", [ "ThirdSuggestion" ] ],
                [ "ThirdRule", [ "FourthSuggestion" ] ] ])
    end

  end

  context "#models_in" do

    before(:each) do
      @model = mock("Model")
    end

    it "should return the result of invoking a method on the model object whose name is the pluralized version of the provided model name" do
      expected_result = (1..3).collect { |i| mock("Model#{i}") }
      @model.should_receive(:some_model_names).and_return(expected_result)

      @configuration.models_in(@model).should eql(expected_result)
    end

  end

  context "#find_next_conventional_bdd_term_suggestions" do

    describe "when provided texts previously suggested" do

      describe "and a multiple texts match multiple suggestion rules" do

        before(:each) do
          @texts = %w(FirstRule SecondRule ThirdRule)
        end

        it "should return the suggestions in the last matching rule" do
          @configuration.find_next_conventional_bdd_term_suggestions(@texts).should eql(["FourthSuggestion"])
        end

      end

      describe "and one text matches one suggestion rule" do

        before(:each) do
          @texts = %w(SomeText SecondRule SomeDifferentText)
        end

        it "should return the suggestions of the rule" do
          @configuration.find_next_conventional_bdd_term_suggestions(@texts).should eql(["ThirdSuggestion"])
        end

      end

      describe "and one text matches one suggestion rule with case differences" do

        before(:each) do
          @texts = %w(SomeText sECONDrULE SomeDifferentText)
        end

        it "should return the suggestions of the rule" do
          @configuration.find_next_conventional_bdd_term_suggestions(@texts).should eql(["ThirdSuggestion"])
        end

      end

      describe "and no texts match any suggestion rule" do

        before(:each) do
          @texts = %w(SomeText SomeDifferentText SomeDifferentTextAgain)
        end

        it "should return nil" do
          @configuration.find_next_conventional_bdd_term_suggestions(@texts).should be_nil
        end

      end

    end

  end

end
