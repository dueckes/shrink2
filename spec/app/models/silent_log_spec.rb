describe SilentLog do

  before(:each) do
    @silent_log = SilentLog.new
  end

  context "#debug" do

    describe "when invoked with a message" do

      it "should execute successfully" do
        lambda { @silent_log.debug("Some message") }.should_not raise_error
      end

    end

  end

end
