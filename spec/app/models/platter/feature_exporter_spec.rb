describe Platter::FeatureExporter do

  context "#export" do

    before(:each) do
      @feature_adapter = mock("FeatureAdapter", :null_object => true)
      @feature = mock("Feature")
      @feature_exporter = Platter::FeatureExporter.new(@feature_adapter)
      FileUtils.stub!(:mkdir_p)
    end

    it "should ensure the destination directory exists by creating it and any parent directories" do
      FileUtils.should_receive(:mkdir_p).with("some directory")

      perform_export
    end

    it "should export the feature to the destination directory on the standard file system via the provided feature adapter" do
      @feature_adapter.should_receive(:to_file).with(@feature, File, "some directory")

      perform_export
    end

    def perform_export
      @feature_exporter.export(:feature => @feature, :destination_directory => "some directory")
    end

  end

end
