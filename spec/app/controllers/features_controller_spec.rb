describe FeaturesController do

  describe "#create" do

    describe "when text is provided in the request" do

      before(:each) do
        Platter::Feature.track_methods(:create!)

        post(:create, :text => "Some Text")
      end

      it "should save a feature with matching text" do
        Platter::Feature.should have_received(:create!).with(:text => "Some Text")
      end

      it "should produce a successful response" do
        response.should be_success
      end

    end

    describe "when no text is provided in the request" do

      it "should establish an error in the flash" do

      end

    end

  end

  describe "#delete" do

    describe "when an id is provided in the request" do

      describe "and the id matches an existing feature" do

        it "should delete that feature" do

        end

        it "should produce a successful response" do
          response.should be_success
        end

      end

    end

    describe "when no id is provided in the request" do

      it "should establish an error in the flash" do

      end

    end

  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET 'list'" do
    it "should be successful" do
      get 'list'
      response.should be_success
    end
  end
end
