describe Shrink::FeatureSummaryChangeObserver do

  shared_examples_for "a before_commit callback that updates all feature summaries" do |callback_method|

    describe "when the observer is associated with one feature" do

      let(:feature) { mock(Shrink::Feature) }

      before(:each) { feature_summary_change_observer.stub!(:feature).and_return(feature) }

      it "should update the features summary" do
        feature.should_receive(:update_summary!)

        feature_summary_change_observer.send(callback_method)
      end

    end

    describe "when the observer is associated with multiple features" do

      let(:features) { (1..3).collect { |i| mock("Feature#{i}").as_null_object } }

      before(:each) do
        feature_summary_change_observer.stub!(:features).with(true)
        feature_summary_change_observer.stub!(:features).with(no_args).and_return(features)
      end

      it "should refresh the features to ensure they are up-to-date" do
        feature_summary_change_observer.should_receive(:features).with(true)

        feature_summary_change_observer.send(callback_method)
      end

      it "should update each features summary" do
        features.each { |feature| feature.should_receive(:update_summary!) }

        feature_summary_change_observer.send(callback_method)
      end

    end

  end

  describe "when the observer is configured to observe save callbacks" do

    class TestableFeatureSummaryChangeObserverOnSave
      include Shrink::FeatureSummaryChangeObserver

      set_observed_callback_methods(:save)
    end

    context "#before_save_commit_when_first_transaction_participant" do

      it_should_behave_like "a before_commit callback that updates all feature summaries",
                            :before_save_commit_when_first_transaction_participant do

        let(:feature_summary_change_observer) { TestableFeatureSummaryChangeObserverOnSave.new }

      end

    end

  end

  describe "when the observer is configured to observe destroy callbacks" do

    class TestableFeatureSummaryChangeObserverOnDestroy
      include Shrink::FeatureSummaryChangeObserver

      set_observed_callback_methods(:destroy)
    end

    context "#before_destroy_commit_when_first_transaction_participant" do

      it_should_behave_like "a before_commit callback that updates all feature summaries",
                            :before_destroy_commit_when_first_transaction_participant do

        let(:feature_summary_change_observer) { TestableFeatureSummaryChangeObserverOnDestroy.new }

      end

    end

  end

end
