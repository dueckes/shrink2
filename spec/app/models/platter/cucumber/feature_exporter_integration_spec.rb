require "tmpdir"

module Platter::Cucumber
  describe FeatureExporter, "#export" do

    before(:all) do
      feature = mock("Feature", :to_cucumber_file_format => "formatted feature text")
      FeatureFileNamer.stub!(:name_for).with(feature).and_return("some_file.feature")
      @destination_directory = Pathname.new(Dir.tmpdir)
      FeatureExporter.export(feature, @destination_directory)

      @feature_file = Pathname.new(@destination_directory + "some_file.feature")
    end
    
    it "should create a file whose name is retrieved via the FeatureFileNamer" do
      @feature_file.should exist
    end
    
    it "should place the file in the provided directory" do
      @feature_file.parent.should eql @destination_directory
    end

    it "should create a file whose containing the cucumber file formatted content" do
      @feature_file.read.should eql("formatted feature text")
    end
    
  end
end
