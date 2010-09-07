describe Shrink::Cucumber::StepMotherFactory do
  
  context ".create" do
  
    before(:each) do
      @options = mock("Cucumber::Cli::Options", :null_object => true)
      ::Cucumber::Cli::Options.stub!(:new).and_return(@options)

      @tag_expression = mock("Gherkin::TagExpression")
      ::Gherkin::TagExpression.stub!(:new).and_return(@tag_expression)

      @step_mother = mock("Cucumber::StepMother", :null_object => true)
      ::Cucumber::StepMother.stub!(:new).and_return(@step_mother)
    end

    it "should create a Cucumber::StepMother instance responsible for reading the file" do
      ::Cucumber::StepMother.should_receive(:new)

      invoke_create
    end

    it "should create an empty Cucumber::Cli::Options instance providing default options to the step mother" do
      ::Cucumber::Cli::Options.should_receive(:new)

      invoke_create
    end

    it "should establish the options of step mother to cucumber command line interface options" do
      @step_mother.should_receive(:options=).with(@options)

      invoke_create
    end

    it "should create a Gherkin::TagExpression instance with empty expression rules when parsing the file" do
      ::Gherkin::TagExpression.should_receive(:new).with([])

      invoke_create
    end

    it "should establish the tag expression on the command line interface options, compensating for a cucumber defect" do
      @options.should_receive(:[]=).with(:tag_expression, @tag_expression)

      invoke_create
    end

    it "should establish a silent log on the step mother instance" do
      @step_mother.should_receive(:log=).with(SilentLog)

      invoke_create
    end

    def invoke_create
      Shrink::Cucumber::StepMotherFactory.create
    end
    
  end
  
end