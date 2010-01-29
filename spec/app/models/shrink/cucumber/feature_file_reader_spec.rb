describe Shrink::Cucumber::FeatureFileReader do

  context "#read" do

    describe "when provided with a file" do

      before(:each) do
        @file = "file.feature"

        @step_mother = mock("Cucumber::StepMother", :null_object => true)
        ::Cucumber::StepMother.stub!(:new).and_return(@step_mother)
        Shrink::Feature.stub!(:adapt)
      end

      it "should log via the SilentLog in the Cucumber::StepMother instance" do
        @step_mother.should_receive(:log=).with(SilentLog)

        Shrink::Cucumber::FeatureFileReader.read(@file)
      end

      it "should delegate to a Cucumber:StepMother to read the file" do
        @step_mother.should_receive(:load_plain_text_features).with([@file]).and_return([])

        Shrink::Cucumber::FeatureFileReader.read(@file)
      end

      it "should convert the Cucumber::Ast::Feature created by the Cucumber::StepMother to a Shrink::Feature" do
        cucumber_ast_feature = mock("Cucumber::Ast::Feature")
        expected_feature = mock("Shrink::Feature")
        Shrink::Feature.should_receive(:adapt).with(cucumber_ast_feature).and_return(expected_feature)

        @step_mother.stub!(:load_plain_text_features).with([@file]).and_return([cucumber_ast_feature])

        Shrink::Cucumber::FeatureFileReader.read(@file).should eql(expected_feature)
      end

    end

  end

end
