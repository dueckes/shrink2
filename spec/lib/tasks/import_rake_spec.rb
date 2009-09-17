describe ":import" do

  context ":directory" do

    before(:each) do
      @task = Rake::Task["import:directory"]
      SimpleLog.stub!(:info)
    end

    describe "when a path is provided as an environment variable" do

      before(:each) do
        @path = "Some Path"
        ENV.stub!(:[]).with("path").and_return(@path)
      end

      it "should delegate to the Platter::Cucumber::FeatureImporter to import the provided path" do
        Platter::Cucumber::FeatureImporter.should_receive(:import_directory).with(@path).and_return([])

        @task.execute
      end

      it "should log the number of features imported via the SimpleLog" do
        features = (1..3).collect { |i| mock("Platter::Feature#{i}") }
        Platter::Cucumber::FeatureImporter.stub!(:import_directory).and_return(features)
        
        SimpleLog.should_receive(:info).with("3 features successfully imported")

        @task.execute
      end

    end

    describe "when no path is provided" do

      before(:each) do
        ENV.stub!(:[]).with("path").and_return(nil)
      end

      it "should raise an error" do
        lambda { @task.execute }.should raise_error("path must be provided")
      end

    end

  end

end
