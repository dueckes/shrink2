describe Shrink::FeatureSummaryChangeObserver do

  describe "A before_commit callback that updates all feature summaries", :shared => true do

    describe "when the observer is associated with one feature" do

      before(:each) do
        @feature = mock("Feature")
        @feautre_summary_change_observer.stub!(:feature).and_return(@feature)
      end

      it "should update the features summary" do
        @feature.should_receive(:update_summary!)

        @feautre_summary_change_observer.send(@callback_method)
      end

    end

    describe "when the observer is associated with multiple features" do

      before(:each) do
        @features = (1..3).collect { |i| mock("Feature#{i}", :null_object => true) }
        @feautre_summary_change_observer.stub!(:features).with(true)
        @feautre_summary_change_observer.stub!(:features).with(no_args).and_return(@features)
      end

      it "should refresh the features to ensure they are up-to-date" do
        @feautre_summary_change_observer.should_receive(:features).with(true)

        @feautre_summary_change_observer.send(@callback_method)
      end

      it "should update each features summary" do
        @features.each { |feature| feature.should_receive(:update_summary!) }

        @feautre_summary_change_observer.send(@callback_method)
      end

    end

  end

  describe "when the observer is configured to observe save callbacks" do

    class TestableFeatureSummaryChangeObserverOnSave
      include Shrink::FeatureSummaryChangeObserver

      set_observed_callback_methods(:save)
    end

    before(:each) do
      @feautre_summary_change_observer = TestableFeatureSummaryChangeObserverOnSave.new
    end

    context "#before_save_commit_when_first_transaction_participant" do

      before(:each) do
        @callback_method = :before_save_commit_when_first_transaction_participant
      end

      it_should_behave_like "A before_commit callback that updates all feature summaries"

    end

  end

  describe "when the observer is configured to observe destroy callbacks" do

    class TestableFeatureSummaryChangeObserverOnDestroy
      include Shrink::FeatureSummaryChangeObserver

      set_observed_callback_methods(:destroy)
    end

    before(:each) do
      @feautre_summary_change_observer = TestableFeatureSummaryChangeObserverOnDestroy.new
    end

    context "#before_destroy_commit_when_first_transaction_participant" do

      before(:each) do
        @callback_method = :before_destroy_commit_when_first_transaction_participant
      end

      it_should_behave_like "A before_commit callback that updates all feature summaries"

    end

  end

end
