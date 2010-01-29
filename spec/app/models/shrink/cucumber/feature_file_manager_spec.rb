module Shrink::Cucumber
  describe FeatureFileManager do

    context "#name_for"  do

      describe "when provided a feature" do

        before(:each) do
          @feature = mock("Feature", :base_filename => "base_file_name")
        end

        it "should return the base filename of the feature with a prefix of '.feature'" do
          FeatureFileManager.name_for(@feature).should eql("base_file_name.feature")
        end

      end

    end

    context "#files_in"  do

      describe "when provided a directory path" do

        before(:each) do
          @directory_path = "some directory path"
        end


        it "should return the files ending with a '.feature' extension within the directory path" do
          features = (1..3).collect { |i| mock("Feature#{i}") }
          Dir.stub!(:glob).with("#{@directory_path}/**/*.feature").and_return(features)
          
          FeatureFileManager.files_in(@directory_path).should eql(features)
        end

      end

    end

  end
end
