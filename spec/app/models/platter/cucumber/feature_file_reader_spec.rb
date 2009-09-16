describe Platter::Cucumber::FeatureFileReader do

  context "#read_files" do

    before(:each) do
      @files = (1..3).collect { |i| "file#{i}.feature"}
      @step_mother = mock("Cucumber::StepMother", :null_object => true)
      ::Cucumber::StepMother.stub!(:new).and_return(@step_mother)
    end

    it "should delegate to a Cucumber:StepMother to read the files" do
      @step_mother.should_receive(:load_plain_text_features).with(@files).and_return([])

      Platter::Cucumber::FeatureFileReader.read_files(@files)
    end

    it "should establish a SilentLog in the Cucumber::StepMother instance" do
      silent_log = mock("SilentLog")
      SilentLog.should_receive(:new).and_return(silent_log)
      @step_mother.should_receive(:log=).with(silent_log)

      Platter::Cucumber::FeatureFileReader.read_files(@files)
    end

    it "should covert each Cucumber::Ast::Feature to a Platter::Feature" do
      cucumber_ast_features = []
      expected_features = []
      (1..3).each do |i|
        cucumber_ast_features << cucumber_ast_feature = mock("Cucumber::Ast::Feature#{i}")
        expected_features << feature = mock("Platter::Feature#{i}")
        Platter::Feature.should_receive(:from).with(cucumber_ast_feature).and_return(feature)
      end

      @step_mother.stub!(:load_plain_text_features).with(@files).and_return(cucumber_ast_features)

      Platter::Cucumber::FeatureFileReader.read_files(@files).should eql(expected_features)
    end

  end

end
