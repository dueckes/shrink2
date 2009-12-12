module Platter
  describe FeatureSummaryChangeObserver do

    describe "when it observes a change to one feature" do

      before(:all) do
        @feature_member_class = Platter::FeatureLine
      end

      before(:each) do
        @feature = DatabaseModelFixture.create_feature!
        @feature_member = @feature_member_class.new(:feature => @feature, :text => "Feature Member Text")
      end

      context "#after_save" do

        before(:each) do
          @feature_member.save!
        end

        it "should update it's associated features summary" do
          @feature.summary.should include(@feature.title)
          @feature.summary.should include("Feature Member Text")
        end

      end

      context "#after_destroy" do

        before(:each) do
          @feature_member.destroy
        end

        it "should update it's associated features summary" do
          @feature.summary.should include(@feature.title)
          @feature.summary.should_not include("Feature Member Text")
        end

      end

    end

    describe "when it observes changes to many features" do

      before(:all) do
        @feature_member_class = Platter::Tag
      end

      before(:each) do
        @feature_member = @feature_member_class.create!(:name => "Feature Member Name")
        @features = (1..3).collect do |i|
          feature = DatabaseModelFixture.create_feature!(:title => "Feature#{i}")
          @feature_member.features << feature
          feature
        end
      end

      context "#after_save" do

        before(:each) do
          @feature_member.update_attributes!(:name => "Updated Feature Member Name")
          @features.each(&:reload)
        end

        it "should update all of it's associated features summaries" do
          @features.each { |feature| feature.summary.should include("Updated Feature Member Name") }
        end

      end

      context "#after_destroy" do

        before(:each) do
          @feature_member.destroy
          @features.each(&:reload)
        end

        it "should update all of it's associated features summaries" do
          @features.each { |feature| feature.summary.should_not include("Feature Member Name") }
        end

      end

    end

  end
end
