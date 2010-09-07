describe Shrink::Cucumber::FeatureFileReader do

  context "#read" do

    describe "when provided with a file" do

      before(:each) do
        @file = "file.feature"

        @cucumber_ast_feature = mock("Cucumber::Ast::Feature", :null_object => true)
        @step_mother = mock("Cucumber::StepMother", :load_plain_text_features => [@cucumber_ast_feature],
                                                    :null_object => true)
        Shrink::Cucumber::StepMotherFactory.stub!(:create).and_return(@step_mother)

        Shrink::Feature.stub!(:adapt)
      end

      it "should create a Cucumber::StepMother instance responsible for reading the file" do
        Shrink::Cucumber::StepMotherFactory.should_receive(:create)

        invoke_read
      end

      it "should delegate to the Cucumber:StepMother to read the file" do
        @step_mother.should_receive(:load_plain_text_features).with([@file])

        invoke_read
      end

      it "should initialize the read feature" do
        @cucumber_ast_feature.should_receive(:init)

        invoke_read
      end

      it "should convert the Cucumber::Ast::Feature created by the Cucumber::StepMother to a Shrink::Feature" do
        expected_feature = mock("Shrink::Feature")
        Shrink::Feature.should_receive(:adapt).with(@cucumber_ast_feature).and_return(expected_feature)

        invoke_read.should eql(expected_feature)
      end

      def invoke_read
        Shrink::Cucumber::FeatureFileReader.read(@file)
      end

    end

  end

end
