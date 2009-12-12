describe Platter::FeatureDescriptionLine do

  describe "Integrating with the database" do

    before(:each) do
      @feature = DatabaseModelFixture.create_feature!
    end

    context "#create!" do

      it "should not require a position" do
        feature_description_line = Platter::FeatureDescriptionLine.create!(:text => "Some Text", :feature => @feature)

        Platter::FeatureDescriptionLine.exists?(feature_description_line).should be_true
      end

    end

  end

end
