describe "A find_similar_texts model method returning persisted texts similar to the text provided", :shared => true do

  before(:all) do
    @all_texts = ["First word in a phrase",
                  "Firstly the outcome was inevitable",
                  "Some phrase that does not start with First",
                  "First second in this minute",
                  "First sec on this day",
                  "Some phrase that does not start with First second",
                  "First second third - it was incrementing in single digits",
                  "First second third the number of clients connecting was increasing",
                  "Some phrase that does not start with First second third"]
  end

  before(:each) do
    @limit = 10
  end

  describe "when the text contains a complete word" do

    before(:each) do
      @text = "First "
      @expected_results = ["First word in a phrase",
                           "First second in this minute",
                           "First sec on this day",
                           "First second third - it was incrementing in single digits",
                           "First second third the number of clients connecting was increasing"].sort
    end

    describe "and the number of candidate results is within the limit" do

      it "should retrieve existing description line texts that start with the word" do
        similar_texts.sort.should eql(@expected_results)
      end

    end

    describe "and the number of candidate results exceeds the limit" do

      before(:each) do
        @limit = 3
      end

      it "should return results whose size is limited to the limit" do
        similar_texts.should eql(@expected_results[0..2])
      end

    end

    it "should retrieve description line texts in alphabetical order" do
      retrieved_texts = similar_texts
      retrieved_texts.sort.should eql(retrieved_texts)
    end

  end

  describe "when the text contains a word and an incomplete word" do

    before(:each) do
      @text = "First sec"
    end

    it "should retrieve existing description line texts that start with the word and the incomplete word" do
      similar_texts.sort.should eql(["First second in this minute", "First sec on this day",
                                     "First second third - it was incrementing in single digits",
                                     "First second third the number of clients connecting was increasing"].sort)
    end

  end

  describe "when the text contains multiple words" do

    before(:all) do
      @expected_similar_texts = ["First second third - it was incrementing in single digits",
                                 "First second third the number of clients connecting was increasing"]
    end

    describe "in the same casing as existing description line texts" do

      before(:each) do
        @text = "First second third"
      end

      it "should retrieve existing description line texts that start with the words" do
        similar_texts.sort.should eql(@expected_similar_texts.sort)
      end

    end

    describe "with casing different than existing description line texts" do

      before(:each) do
        @text = "fIRST SECOND tHiRd"
      end

      it "should ignore the casing and retrieve existing description line texts that start with the words" do
        similar_texts.sort.should eql(@expected_similar_texts.sort)
      end

    end

  end

  def similar_texts
    @model.find_similar_texts(@text, @limit)
  end

end
