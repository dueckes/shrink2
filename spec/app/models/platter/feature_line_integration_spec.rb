describe Platter::FeatureLine do

  describe "Integrating with the database" do

    before(:each) do
      @feature = DatabaseModelFixture.create_feature!
    end

    describe "#create!" do

      it "should not require a position" do
        feature_line = Platter::FeatureLine.create!(:text => "Some Text", :feature => @feature)

        Platter::FeatureLine.exists?(feature_line).should be_true
      end

    end

  end

end
