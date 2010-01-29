describe ":import" do

  context ":features" do

    before(:each) do
      @task = Rake::Task["import:features"]
      SimpleLog.stub!(:info)
    end

    describe "when a path is provided as an environment variable" do

      before(:each) do
        @path = "Some Path"
        ENV.stub!(:[]).with("path").and_return(@path)
      end

      it "should delegate to the Shrink::FeatureImporter to import the provided path" do
        FEATURE_IMPORTER.should_receive(:import).with(:directory_path => @path).and_return([])

        @task.execute
      end

      describe "when all features are imported without error" do

        before(:each) do
          @features = (1..3).collect { |i| mock("Shrink::Feature#{i}", :valid? => true) }
          FEATURE_IMPORTER.stub!(:import).and_return(@features)
        end

        it "should log the number of features imported via the SimpleLog" do
          SimpleLog.should_receive(:info).with("3 features successfully imported")

          @task.execute
        end

      end

      describe "when some features are imported with errors" do

        before(:each) do
          @features = (1..5).collect { |i| mock("Shrink::Feature#{i}",
                                                :valid? => i % 2 == 0,
                                                :errors => i % 2 == 0 ? [] : create_errors(i)) }
          FEATURE_IMPORTER.stub!(:import).and_return(@features)
        end

        it "should log a message indicating the number of errors that occurred during the import" do
          SimpleLog.should_receive(:info).with("Encountered 3 errors during import.  No features were imported.")

          @task.execute
        end

        it "should log a message detailing the errors in each feature having errors" do
          expected_error_messages = [1, 3, 5].collect { |i| (1..3).collect { |j| "Error Message #{i} #{j}" } }.flatten
          expected_error_message = expected_error_messages.join("\n")
          SimpleLog.should_receive(:info).with("Error details:\n#{expected_error_message}")

          @task.execute
        end

        def create_errors(i)
          mock("Errors", :full_messages => (1..3).collect { |j| "Error Message #{i} #{j}" })
        end

      end

    end

    describe "when no path is provided" do

      before(:each) do
        ENV.stub!(:[]).with("path").and_return(nil)
      end

      it "should raise an error" do
        lambda { @task.execute }.should raise_error("path to feature directory must be provided")
      end

    end

  end

end
