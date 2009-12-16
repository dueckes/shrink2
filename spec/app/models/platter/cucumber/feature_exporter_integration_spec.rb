require 'tmpdir'

describe Platter::Cucumber::FeatureExporter do

  context "#export_to_directory" do

    before(:all) do
      @feature = mock("Feature", :to_cucumber_file_format => "formatted feature text")
      Platter::Cucumber::FeatureFileNamer.stub!(:name_for).with(@feature).and_return("some_file.feature")
      @destination_directory = Dir.tmpdir

      @feature_file_path = Platter::Cucumber::FeatureExporter.export_to_directory(@feature, @destination_directory)
      @feature_file = File.new(@feature_file_path)
    end

    it "should return the path to the feature file named via the FeatureFileNamer" do
      @feature_file_path.should eql("#{@destination_directory}/some_file.feature")
    end

    it "should create a file" do
      File.exist?(@feature_file).should be_true
    end

    it "should create a file whose containing the cucumber file formatted content" do
      @feature_file.read.should eql("formatted feature text")
    end

  end

end
