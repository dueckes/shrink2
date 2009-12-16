describe Platter::Cucumber::FeatureExporter do

  context "#export" do

    before(:each) do
      @feature = mock("Feature", :to_cucumber_file_format => "formatted feature text")
    end

    it "should delegate to #export_to_directory using the default Feature export directory" do
      Platter::Cucumber::FeatureExporter.should_receive(:export_to_directory).with(
              @feature, Platter::Feature::EXPORT_DIRECTORY)

      Platter::Cucumber::FeatureExporter.export(@feature)
    end

    it "should return the created files path" do
      Platter::Cucumber::FeatureExporter.stub!(:export_to_directory).and_return("file path")

      Platter::Cucumber::FeatureExporter.export(@feature).should eql("file path")
    end

  end

end
