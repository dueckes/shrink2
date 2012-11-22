describe ":prime:data" do

  describe "integrating with the database" do
    include_context "database integration"

    context ":features" do

      before(:all) do
        @task = Rake::Task["prime:data:features"]

        @initial_simple_log = SimpleLog
        SimpleLog = RecordingLog
      end

      after(:all) do
        SimpleLog = @initial_simple_log
      end

      describe "when the data priming project does not exist" do
        include_context "clear database after all"

        before(:all) do
          @task.execute
        end

        it "should create the data priming project" do
          data_priming_project.should_not be_nil
        end

      end

      describe "when the data priming project exists" do
        include_context "clear database after all"

        before(:all) do
          create_data_priming_project

          @task.execute
        end

        it "should add features to the data priming projects root folder" do
          data_priming_project.root_folder.features.should_not be_empty
        end

        it "should not create another project with the same name" do
          Shrink::Project.count(:conditions => ["name = ?", "Data Priming Project"]).should eql(1)
        end

      end

      describe "when no primed features exist" do
        include_context "clear database after all"

        before(:all) do
          @task.execute
        end
        
        it "should create features in the data priming project starting with the number 1" do
          data_priming_project_features.collect(&:title).sort.first.should eql("Rake Feature 1")
        end

      end

      describe "when primed features exist" do
        include_context "clear database after all"

        before(:all) do
          create_data_priming_project
          (1..3).each { |i| create_feature!(:title => "Rake Feature #{i}",
                                            :folder => data_priming_project.root_folder) }
          @task.execute
        end

        it "should create features starting with a number one greater than the number of the largest primed feature" do
          (1..4).each { |i| verify_unique_feature_exists_having_number(i) }
        end

      end

      describe "when not provided a number of features to create" do
        include_context "clear database after all"

        before(:all) do
          @task.execute
        end

        it "should create one feature" do
          data_priming_project_features.should have(1).feature
        end

      end

      describe "when provided a number of features to create" do
        include_context "clear database after all"

        before(:all) do
          @initial_number_value = ENV["number"]
          ENV["number"] = "8"

          RecordingLog.reset

          @task.execute
        end

        after(:all) do
          ENV["number"] = @initial_number_value
        end

        it "should log that the provided number of features are being created" do
          RecordingLog.messages.should include("Creating 8 feature(s)...")
        end

        it "should create features whose number is incremented by 1" do
          (1..8).each { |i| verify_unique_feature_exists_having_number(i) }
        end

        it "should create that number of features in the data priming project" do
          data_priming_project_features.should have(8).features
        end

      end

      def data_priming_project
        @data_priming_project ||= Shrink::Project.find_by_name("Data Priming Project")
      end

      def data_priming_project_features
        data_priming_project.features.all
      end

      def create_data_priming_project
        @data_priming_project ||= Shrink::Project.create!(:name => "Data Priming Project")
      end

      def verify_unique_feature_exists_having_number(number)
        Shrink::Feature.count(:conditions => ["title = ?", "Rake Feature #{number}"]).should eql(1)
      end

    end

  end

end
