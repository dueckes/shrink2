describe Shrink::FolderImporter do

  before(:each) do
    @feature_importer = mock(Shrink::FeatureImporter).as_null_object
    @destination_folder = mock(Shrink::Folder)
    @features = (1..3).collect { |i| mock("Feature#{i}") }
  end

  context "#import" do

    before(:each) do
      @folder_importer = Shrink::FolderImporter.new(@feature_importer)

      @zip_importer = mock("ZipImporter").as_null_object
      Shrink::FolderImporter::ZipImporter.stub!(:new).and_return(@zip_importer)
    end

    it "should perform the import via a ZipImporter" do
      Shrink::FolderImporter::ZipImporter.should_receive(:new).with(hash_including(
              :feature_importer => @feature_importer, :zip_file_path => "zip file path",
              :extract_root_directory => "extract root directory",
              :destination_folder => @destination_folder)).and_return(@zip_importer)
      @zip_importer.should_receive(:import)

      perform_import
    end

    it "should return the features created via the ZipImporter" do
      @zip_importer.stub!(:import).and_return(@features)

      perform_import.should eql(@features)
    end

    def perform_import
      @folder_importer.import(:zip_file_path => "zip file path",
                              :extract_root_directory => "extract root directory",
                              :destination_folder => @destination_folder)
    end

  end

  describe Shrink::FolderImporter::ZipImporter do

    before(:each) do
      @zip_importer = Shrink::FolderImporter::ZipImporter.new(
              :feature_importer => @feature_importer, :zip_file_path => "zip directory/zip file.zip",
      :extract_root_directory => "extract root directory", :destination_folder => @destination_folder)
      @expected_extract_directory = "extract root directory/zip file"

      ::Zip::ZipFile.stub!(:extract)
      FileUtils.stub!(:rm_rf)
    end

    context "#import" do

      it "should extract the zip file to a directory combining the extract root directory and zip file name" do
        ::Zip::ZipFile.should_receive(:extract).with("zip directory/zip file.zip", @expected_extract_directory)

        perform_import
      end

      it "should delegate to the feature importer to import the extracted directory into the destination folder" do
        @feature_importer.should_receive(:import).with(hash_including(
                :directory_path => @expected_extract_directory,
                :destination_folder => @destination_folder))

        perform_import
      end

      it "should return the features imported via the feature importer" do
        @feature_importer.stub!(:import).and_return(@features)

        perform_import.should eql(@features)
      end

      it "should delete the extract directory on completion" do
        FileUtils.should_receive(:rm_rf).with(@expected_extract_directory)

        perform_import
      end

      describe "when a ZipError occurs extracting the zip file" do

        before(:each) do
          ::Zip::ZipFile.stub!(:extract).and_raise(::Zip::ZipError.new("Some error message"))
        end


        it "should raise an error indicating the zip file is invalid" do

          lambda { perform_import }.should raise_error(Shrink::ImportError, "Zip file is invalid")
        end

      end

      def perform_import
        @zip_importer.import
      end

    end

  end

end
