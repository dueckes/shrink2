describe Shrink::StepTextSuggester::ConventionalBddTermSuggester do

  context "#suggestions_for" do

    describe "when provided a context containing text, text position and previous step texts" do

      before(:each) do
        @texts_before = []
      end

      describe "when the text is an incomplete word" do

        before(:each) do
          @text = "Word"
        end

        describe "and the position is at the start of the scenario" do

          before(:each) do
            @position = 0
          end

          it "should return 'Given'" do
            suggestions.should eql(["Given"])
          end

        end

        describe "and the position is after a 'Given' step" do

          before(:each) do
            add_step_text("Given this")
            @position = 1
          end

          it "should return 'And' and 'When'" do
            suggestions.should eql(["And", "When"])
          end

        end

        describe "and the position is after a 'Given' step in mixed case" do

          before(:each) do
            add_step_text("gIvEn this")
            @position = 1
          end

          it "should return 'And' and 'When'" do
            suggestions.should eql(["And", "When"])
          end

        end

        describe "and the position is after an 'And' step that follows a 'Given' step" do

          before(:each) do
            add_step_text("Given this", "And this", "And that", "And that also")
            @position = 4
          end

          it "should return 'And' and 'When'" do
            suggestions.should eql(["And", "When"])
          end

        end

        describe "and the position is after a 'When' step" do

          before(:each) do
            add_step_text("Given this", "When this")
            @position = 2
          end

          it "should return 'And' and 'Then'" do
            suggestions.should eql(["And", "Then"])
          end

        end

        describe "and the position is after an 'And' step that follows a 'When' step" do

          before(:each) do
            add_step_text("Given this", "When this", "And this", "And that", "And that also")
            @position = 5
          end

          it "should return 'And' and 'Then'" do
            suggestions.should eql(["And", "Then"])
          end

        end

        describe "and the position is after a 'Then' step" do

          before(:each) do
            add_step_text("Given this", "When this", "Then this")
            @position = 3
          end

          it "should return 'And'" do
            suggestions.should eql(["And"])
          end

        end

        describe "and the position is after an 'And' step that follows a 'Then' step" do

          before(:each) do
            add_step_text("Given this", "When this", "Then this", "And this", "And that", "And that also")
            @position = 6
          end

          it "should return 'And'" do
            suggestions.should eql(["And"])
          end

        end

      end

      describe "when the text is empty" do

        before(:each) do
          @text = ""
          @position = 0
        end

        it "should still offer suggestions based on step texts before the current position" do
          suggestions.should eql(["Given"])
        end

      end

    end

    def add_step_text(*texts)
      @texts_before.concat(texts)
    end

    def suggestions
      context = mock("Context", :text => @text, :position => @position, :texts_before => @texts_before)
      Shrink::StepTextSuggester::ConventionalBddTermSuggester.suggestions_for(context)
    end

  end

end
