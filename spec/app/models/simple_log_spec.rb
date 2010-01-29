describe SimpleLog do

  context "#info" do

    describe "when invoked with a message" do

      it "should direct the message to stdout" do
        message = "Some Message"
        SimpleLog.should_receive(:puts).with(message)

        SimpleLog.info(message)
      end

    end

  end

end
