describe Shrink::TextSuggester::Context::Suggestions do

  before(:each) do
    @suggestions = Shrink::TextSuggester::Context::Suggestions.new
  end

  context "#add" do

    describe "when less than the maximum number of suggestions have been added" do

      it "should add a suggestion" do
        added_suggestion = "Suggestion"
        @suggestions.add(added_suggestion)

        @suggestions.to_a.should eql([added_suggestion])
      end

      it "should add an array of suggestions" do
        added_suggestions = (1..3).collect { |i| "Suggestion#{i}" }
        @suggestions.add(added_suggestions)

        @suggestions.to_a.should eql(added_suggestions)
      end

    end

    describe "when the maximum number of suggestions have been added" do

      before(:each) do
        add_suggestions(Shrink::TextSuggester::Context::Suggestions::MAXIMUM)
      end

      it "should not add a suggestions" do
        @suggestions.add("Another suggestion")

        @suggestions.to_a.should eql(@suggestions_added)
      end

    end

  end

  context "#number_allowed" do

    describe "when no suggestions have been added" do

      it "should return the maximum number of suggestions allowed" do
        @suggestions.number_allowed.should eql(Shrink::TextSuggester::Context::Suggestions::MAXIMUM)
      end

    end

    describe "when 3 suggestions have been added" do

      before(:each) do
        add_suggestions(3)
      end

      it "should return the 3 less than the maximum number of suggestions allowed" do
        @suggestions.number_allowed.should eql(Shrink::TextSuggester::Context::Suggestions::MAXIMUM - 3)
      end

    end

    describe "when the maximum number of suggestions have been added" do

      before(:each) do
        add_suggestions(Shrink::TextSuggester::Context::Suggestions::MAXIMUM)
      end

      it "should return 0" do
        @suggestions.number_allowed.should eql(0)
      end

    end

  end

  context "#more_allowed?" do

    describe "when no suggestions have been added" do

      it "should return true" do
        @suggestions.more_allowed?.should be_true
      end

    end

    describe "when 3 suggestions have been added" do

      before(:each) do
        add_suggestions(3)
      end

      it "should return true" do
        @suggestions.more_allowed?.should be_true
      end

    end


    describe "when the maximum number of suggestions have been added" do

      before(:each) do
        add_suggestions(Shrink::TextSuggester::Context::Suggestions::MAXIMUM)
      end

      it "should return false" do
        @suggestions.more_allowed?.should be_false
      end

    end

  end

  context "#to_a" do

    it "should return an array that, when changed, does not alter the suggestions" do
      @suggestions.to_a << "Some suggestion"

      @suggestions.to_a.should_not include("Some suggestion")
    end

    describe "when no suggestions have been added" do

      it "should return an empty array" do
        @suggestions.to_a.should be_an(Array)
        @suggestions.to_a.should be_empty
      end

    end

    describe "when suggestions have been added" do

      before(:each) do
        add_suggestions(3)
      end

      it "should return an array containing the suggestions in the order they were added" do
        @suggestions.to_a.should eql(@suggestions_added)
      end

    end

  end

  def add_suggestions(number)
    @suggestions_added = (1..number).collect { |i| "Suggestion#{i}" }
    @suggestions.add(@suggestions_added)
  end

end
