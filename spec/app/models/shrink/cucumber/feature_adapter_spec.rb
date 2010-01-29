describe Shrink::Cucumber::FeatureAdapter do

  context "#to_feature" do

    describe "when a file is provided" do

      before(:each) do
        @file = mock("File")
      end

      it "should adapt the file to a feature via the Shrink::Cucumber::FeatureFileReader" do
        feature = mock("Feature")
        Shrink::Cucumber::FeatureFileReader.should_receive(:read).with(@file).and_return(feature)

        Shrink::Cucumber::FeatureAdapter.to_feature(@file).should eql(feature)
      end

    end

  end

  context "#to_file" do

    describe "when a feature, file system and destination directory are provided" do

      before(:each) do
        @feature = mock("Feature", :to_cucumber_file_format => "cucumber_formatted_string")
        @file_system = mock("FileSystem", :open => nil)
        @destination_directory = "some directory"
        Shrink::Cucumber::FeatureFileManager.stub!(:name_for).and_return("file name")
      end

      describe "when the destination directory is not nil" do

        it "should create a file on the file system whose directory path is the destination directory" do
          @file_system.should_receive(:open).with(/^some directory/, "w")

          to_file
        end

      end

      describe "when the destination directory is nil" do

        before(:each) do
          @destination_directory = nil
        end

        it "should create a file on the file system with no directory path" do
          @file_system.should_receive(:open).with(/[^\/]/, "w")

          to_file
        end

      end

      it "should create a file on the file system whose name is provided by the Shrink::Cucumber::FeatureFileManager" do
        Shrink::Cucumber::FeatureFileManager.should_receive(:name_for).with(@feature).and_return("feature file name")
        @file_system.should_receive(:open).with(/\/feature file name$/, "w")
        
        to_file
      end

      it "should write the cucumber file formatted representation of the feature to the file on the file system" do
        file = mock("File")
        file.should_receive(:<<).with("cucumber_formatted_string")
        @file_system.stub!(:open).and_yield(file)

        to_file
      end

      it "should return the path to the created file" do
        to_file.should match(/\/file name$/)
      end

      def to_file
        Shrink::Cucumber::FeatureAdapter.to_file(@feature, @file_system, @destination_directory)
      end

    end

  end

end
