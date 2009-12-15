describe PhraseHighlightHelper do

  class TestablePhraseHighlightHelper
    include PhraseHighlightHelper
  end

  before(:each) do
    @phrase_highlight_helper = TestablePhraseHighlightHelper.new
  end

  context "#highlight_phrase_in_text" do

    describe "when the text contains the phrase" do

      describe "once" do

        before(:each) do
          @result = @phrase_highlight_helper.highlight_phrase_in_text("phrase", "some text containing the phrase")
        end

        it "should return the text with the phrase in bold" do
          @result.should eql("some text containing the <b>phrase</b>")
        end

      end

      describe "many times" do

        before(:each) do
          @result = @phrase_highlight_helper.highlight_phrase_in_text(
                  "phrase", "first phrase, second phrase, third phrase")
        end

        it "should return the text with the phrase in bold" do
          @result.should eql("first <b>phrase</b>, second <b>phrase</b>, third <b>phrase</b>")
        end

      end

      describe "and the phrase contains special characters" do

        before(:each) do
          @result = @phrase_highlight_helper.highlight_phrase_in_text(
                  ".\\phrase^$", "some @#.\\phrase^$()")
        end
        
        it "should highlight the occurrences of the phrase, including the special characters" do
          @result.should eql("some @#<b>.\\phrase^$</b>()")
        end

      end

      describe "in a different case" do

        before(:each) do
          @result = @phrase_highlight_helper.highlight_phrase_in_text(
                  "phrase", "SomE TEXT contAiNing the PhrAsE")
        end

        it "should highlight the text" do
          @result.should eql("SomE TEXT contAiNing the <b>PhrAsE</b>")
        end

      end

    end

    describe "when the text does not contain the phrase" do

      it "should return the text unaltered" do
        @phrase_highlight_helper.highlight_phrase_in_text("some phrase", "some text").should eql("some text")
      end

    end

  end

end
