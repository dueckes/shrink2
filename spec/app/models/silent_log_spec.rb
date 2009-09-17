describe SilentLog do

  context "#debug" do

    describe "when invoked with a message" do

      it "should execute successfully" do
        lambda { SilentLog.debug("Some message") }.should_not raise_error
      end

    end

  end

end
