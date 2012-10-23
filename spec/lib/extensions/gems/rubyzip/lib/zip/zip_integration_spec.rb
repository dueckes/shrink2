describe ::Shrink::Zip::ZipFile do

  class TestableZipFile
    include ::Shrink::Zip::ZipFile
  end

  describe "integrating with the file system" do

    context "#extract" do

      before(:all) do
        source_directory = SPEC_RESOURCES_DIR
        @destination_directory = "#{SPEC_TMP_DIR}/zip_integration_spec"
        @zip_with_files = "#{source_directory}/feature_zip_with_features.zip"
        @zip_with_directories_and_files = "#{source_directory}/feature_zip_with_directories_and_features.zip"
      end

      after(:all) do
        FileUtils.rm_rf(@destination_directory)
      end

      describe "when the provided directory does not exist" do

        before(:all) do
          TestableZipFile.extract(@zip_with_files, @destination_directory)
        end

        it "should create it" do
          File.exist?(@destination_directory).should be_true
        end

      end

      describe "when the directory already exists" do

        before(:all) do
          FileUtils.mkdir_p(@destination_directory)
          @temporary_file_in_directory = "#{@destination_directory}/test.txt"
          File.open(@temporary_file_in_directory, "w") { |file| file << "Test" }
          TestableZipFile.extract(@zip_with_files, @destination_directory)
        end

        it "should replace it" do
          File.exist?(@destination_directory).should be_true
          File.exist?(@temporary_file_in_directory).should be_false
        end

      end

      describe "when the zip contains files" do

        before(:all) do
          TestableZipFile.extract(@zip_with_files, @destination_directory)
        end

        it "should extract the files to the directory" do
          (1..3).each do |i|
            file_path = "#{@destination_directory}/#{i} Feature.feature"
            File.exist?(file_path).should be_true
            File.size(file_path).should > 0
          end
        end

      end

      describe "when the zip contains files in directories" do

        before(:all) do
          TestableZipFile.extract(@zip_with_directories_and_files, @destination_directory)
        end

        it "should extract the top level directories within the provided directory" do
          (1..3).each do |i|
            sub_directory_path = "#{@destination_directory}/#{i} Folder"
            File.exist?(sub_directory_path).should be_true
          end
        end

        it "should extract nested directories within the provided directory" do
          File.exist?("#{@destination_directory}/1 Folder/1-1 Folder").should be_true
        end

        it "should extract files within top level directories to the provided directory" do
          (1..3).each do |i|
            file_path = "#{@destination_directory}/1 Folder/1-#{i} Feature.feature"
            File.exist?(file_path).should be_true
          end
        end

        it "should extract files within nested directories to the nested directories in the provided directory" do
          File.exist?("#{@destination_directory}/1 Folder/1-1 Folder/1-1-1 Feature.feature").should be_true
        end

      end

    end

  end

end
