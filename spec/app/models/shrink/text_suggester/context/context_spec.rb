describe Shrink::TextSuggester::Context::Context do

  before(:each) do
    @configuration = mock("Configuration").as_null_object
    @parent_model = mock("ParentModel")
  end

  context "#configuration" do

    it "should return the provided configuration" do
      create_context

      @context.configuration.should eql(@configuration)
    end

  end

  context "#suggestions" do

    it "should return the suggestions created when the context is created" do
      expected_suggestions = mock("Suggestions")
      Shrink::TextSuggester::Context::Suggestions.should_receive(:new).and_return(expected_suggestions)

      create_context

      @context.suggestions.should eql(expected_suggestions)
    end

  end

  context "#find_next_conventional_bdd_term_suggestions" do

    before(:each) do
      create_context
    end

    it "should delegate and the return the result from invoking the configuration" do
      @configuration.should_receive(:find_next_conventional_bdd_term_suggestions).and_return(create_expected_suggestions)

      @context.find_next_conventional_bdd_term_suggestions.should eql(@expected_suggestions)
    end

    it "should return suggestions based on other texts up to and including the position" do
      models = (1..10).collect { |i| mock("Model#{i}", :text => "Text#{i}") }
      @configuration.stub!(:models_in).with(@parent_model).and_return(models)

      @configuration.should_receive(:find_next_conventional_bdd_term_suggestions).with((1..8).collect { |i| "Text#{i}" })

      @context.find_next_conventional_bdd_term_suggestions
    end

  end

  context "#find_similar_existing_texts" do

    before(:each) do
      project = mock("Project")
      feature = mock("Feature", :project => project)
      @parent_model.stub!(:feature).and_return(feature)

      @project_models = mock("ProjectModels")
      @configuration.should_receive(:models_in).with(project).and_return(@project_models)

      @suggestions = mock("Suggestions").as_null_object
      Shrink::TextSuggester::Context::Suggestions.stub!(:new).and_return(@suggestions)

      create_context
    end

    it "should return similar texts for the model in the entire project" do
      @project_models.should_receive(:find_similar_texts).with("Some Text", anything).and_return(
              create_expected_suggestions)

      @context.find_similar_existing_texts.should eql(@expected_suggestions)
    end

    it "should return similar texts limited to the number of suggestions allowed" do
      @suggestions.stub!(:number_allowed).and_return(2)

      @project_models.should_receive(:find_similar_texts).with(anything, 2)

      @context.find_similar_existing_texts
    end

  end

  def create_context
    @context = Shrink::TextSuggester::Context::Context.new(@configuration, "Some Text", 8, @parent_model)
  end

  def create_expected_suggestions
    @expected_suggestions = (1..3).collect { |i| "Suggestion#{i}" }
  end

end
