describe Shrink::Cucumber::FeatureFileReader do

  context "#read" do

    describe "when provided with a file" do

      before(:each) do
        @file = "file.feature"

        @cucumber_ast_feature = mock(Cucumber::Ast::Feature).as_null_object
        @feature_file = mock(::Cucumber::FeatureFile, :parse => @cucumber_ast_feature).as_null_object
        ::Cucumber::FeatureFile.stub!(:new).and_return(@feature_file)

        Shrink::Feature.stub!(:adapt)
      end

      it "should create a Cucumber::FeatureFile responsible for parsing the file" do
        ::Cucumber::FeatureFile.should_receive(:new).with(@file)

        invoke_read
      end

      it "should delegate to the Cucumber:FeatureFile to parse the file" do
        @feature_file.should_receive(:parse).with({}, {})

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
