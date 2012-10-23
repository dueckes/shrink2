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

      describe "and a project is provided as an environment variable" do

        before(:each) do
          @project_name = "Some Project"
          ENV.stub!(:[]).with("project").and_return(@project_name)
        end

        describe "and the project is found" do

          before(:each) do
            @root_folder = mock("Shrink::Folder")
            Shrink::Project.stub!(:find_by_name).with(@project_name).and_return(create_project(@root_folder))
          end

          it "should delegate to the Shrink::FeatureImporter to import the provided path into the projects root folder" do
            FEATURE_IMPORTER.should_receive(:import).with(:directory_path => @path, :destination_folder => @root_folder).and_return([])

            @task.execute
          end

          describe "and all features are imported without error" do

            before(:each) do
              @features = (1..3).collect { |i| mock("Shrink::Feature#{i}", :valid? => true) }
              FEATURE_IMPORTER.stub!(:import).and_return(@features)
            end

            it "should log the number of features imported via the SimpleLog" do
              SimpleLog.should_receive(:info).with("3 features successfully imported into project 'Some Project'")

              @task.execute
            end

          end

          describe "and some features are imported with errors" do

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

        describe "and the project is not found" do

          before(:each) do
            Shrink::Project.stub!(:find_by_name).and_return(nil)
          end

          it "should raise an error" do
            lambda { @task.execute }.should raise_error("project 'Some Project' does not exist")
          end

        end

      end

      describe "and no project is provided" do

        before(:each) do
          ENV.stub!(:[]).with("project").and_return(nil)
        end

        it "should delegate to the Shrink::FeatureImporter to import the provided path into the default projects root folder" do
          root_folder = mock("Shrink::Folder")
          Shrink::Project.stub!(:default).and_return(create_project(root_folder))
          FEATURE_IMPORTER.should_receive(:import).with(:directory_path => @path, :destination_folder => root_folder).and_return([])

          @task.execute
        end

      end

      def create_project(root_folder)
        mock("Shrink::Project", :name => @project_name, :root_folder => root_folder)
      end

    end

    describe "when no path is provided" do

      before(:each) do
        ENV.stub!(:[]).with("path").and_return(nil)
      end

      it "should raise an error" do
        lambda { @task.execute }.should raise_error("path=path/to_feature_directory must be provided")
      end

    end

  end

end
