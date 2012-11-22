describe Shrink::FeatureDescriptionLine do

  describe "integrating with the database" do
    include_context "database integration"

    before(:all) do
      @feature = create_feature!
    end

    context "#create!" do

      it "should not require a position" do
        feature_description_line = Shrink::FeatureDescriptionLine.create!(:text => "Some Text", :feature => @feature)

        Shrink::FeatureDescriptionLine.exists?(feature_description_line).should be_true
      end

    end

  end

end
