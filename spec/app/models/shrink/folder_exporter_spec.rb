describe Shrink::FolderExporter do

  context "#export" do

    before(:each) do
      @feature_adapter = mock("FeatureAdapter")
      @folder_exporter = Shrink::FolderExporter.new(@feature_adapter)
      @folder = mock("Folder")

      @zip_exporter = mock("ZipExporter").as_null_object
      Shrink::FolderExporter::ZipExporter.stub!(:new).and_return(@zip_exporter)
    end

    it "should perform the export via a ZipExporter" do
      Shrink::FolderExporter::ZipExporter.should_receive(:new).with(hash_including(
              :feature_adapter => @feature_adapter, :folder => @folder,
              :zip_root_directory => "zip root directory")).and_return(@zip_exporter)
      @zip_exporter.should_receive(:export)

      perform_export
    end

    it "should return path to the zip file created by the ZipExporter" do
      @zip_exporter.stub!(:export).and_return("zip file path")

      perform_export.should eql("zip file path")
    end

    def perform_export
      @folder_exporter.export(:folder => @folder, :zip_root_directory => "zip root directory")
    end

  end

end
