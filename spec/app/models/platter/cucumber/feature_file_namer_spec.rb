module Platter::Cucumber
  describe FeatureFileNamer do

    context "#name_for"  do

      describe "when provided a feature" do

        before(:each) do
          @feature = mock("Feature", :base_filename => "base_file_name")
        end

        it "should return the base filename of the feature with a prefix of '.feature'" do
          FeatureFileNamer.name_for(@feature).should eql("base_file_name.feature")
        end

      end

    end

  end
end
