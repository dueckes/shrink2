describe String do

  context "#as_folder_names" do

    describe "when the string is empty" do

      before(:each) do
        @string = ""
      end

      it "should return an empty array" do
        @string.as_folder_names.should eql([])
      end

    end

    describe "when the string contains a single folder name" do

      before(:each) do
        @string = "folder"
      end

      it "should return an array containing the folder name" do
        @string.as_folder_names.should eql([@string])
      end

    end

    describe "when the string starts and ends in a path separator" do

      before(:each) do
        @string = "/folder/"
      end

      it "should return an array containing the string without the separators" do
        @string.as_folder_names.should eql(["folder"])
      end

    end

    describe "when the string contains a folder structure" do

      before(:each) do
        @string = "first/second/third"
      end

      it "should return the names of the folders in order of appearance in the string" do
        @string.as_folder_names.should eql(%w(first second third))
      end

    end

  end

  context "#fileize" do

    describe "when a string contains alphanumeric characters having different casing, underscores, hyphens and whitespace" do

      before(:all) do
        @string = "String with_underscores-Hypens and spaces 1"
      end

      it "should return the string unaltered" do
        @string.fileize.should eql("String with_underscores-Hypens and spaces 1")
      end

    end

    describe "when a string contains characters other than alphanumerics, underscores, hypens and whitespace" do

      before(:all) do
        @string = 'String!@#$%+)(*&^"'
      end

      it "should return a string with non-alphanumerics, underscores, hypens and whitespace characters removed" do
        @string.fileize.should eql("String")
      end

    end

    describe "when the string is surrounded by whitespace" do

      before(:all) do
        @string = " surrounded by whitespace "
      end

      it "should return a string with the surrounding whitespace removed" do
        @string.fileize.should eql("surrounded by whitespace")
      end

    end

    it "should not alter the original string" do
      string = "*string*"
      string.fileize

      string.should eql("*string*")
    end

  end

  context "#underscoreize" do

    describe "when the string contains spaces" do

      before(:all) do
        @string = "string with spaces"
      end

      it "should return the string with spaces converted to underscores" do
        @string.underscoreize.should eql("string_with_spaces")
      end

    end

    describe "when the string does not contain spaces" do

      before(:all) do
        @string = "string_without-spaces"
      end

      it "should return the string unaltered" do
        @string.underscoreize.should eql("string_without-spaces")
      end

    end

    it "should not alter the original string" do
      string = "some string"
      string.underscoreize

      string.should eql("some string")
    end

  end

  context "#contains_complete_word?" do

    describe "when the string contains a word followed by a space" do

      before(:each) do
        @string = "word "
      end

      it "should return true" do
        @string.contains_complete_word?.should be_true
      end

    end

    describe "when the string contains a word followed by a tab" do

      before(:each) do
        @string = "word\t"
      end

      it "should return true" do
        @string.contains_complete_word?.should be_true
      end

    end

    describe "when the string contains a word followed by a carriage-return" do

      before(:each) do
        @string = "word\n"
      end

      it "should return true" do
        @string.contains_complete_word?.should be_true
      end

    end

    describe "when the string contains multiple words" do

      before(:each) do
        @string = "word followed by many more words"
      end
      
      it "should return true" do
        @string.contains_complete_word?.should be_true
      end

    end

    describe "when the string contains a word without whitespace" do

      before(:each) do
        @string = "word"
      end

      it "should return false" do
        @string.contains_complete_word?.should be_false
      end

    end

    describe "when the string is empty" do

      before(:each) do
        @string = ""
      end

      it "should return false" do
        @string.contains_complete_word?.should be_false
      end

    end

  end

  context "#preview" do

    describe "when the string contains the same number of lines to be previewed" do

      before(:all) do
        @string = "a\nb\nc"
      end

      describe "and the text to match is in the first line" do

        it "should return the entire string" do
          @string.preview("a", 1).should eql(@string)
        end

      end

      describe "and the text to match is in a line in the middle" do

        it "should return the entire string" do
          @string.preview("b", 1).should eql(@string)
        end

      end

      describe "and the text to match is in the last line" do

        it "should return the entire string" do
          @string.preview("c", 1).should eql(@string)
        end

      end

    end

    describe "when the string contains less lines than the preview length" do

      before(:all) do
        @string = "a\nb\nc\nd\ne"
      end

      describe "and the text to match is in the first line" do

        it "should return the entire string" do
          @string.preview("a", 3).should eql(@string)
        end

      end

      describe "and the text to match is in a line in the middle" do

        it "should return the entire string" do
          @string.preview("c", 3).should eql(@string)
        end

      end

      describe "and the text to match is in the last line" do

        it "should return the entire string" do
          @string.preview("e", 3).should eql(@string)
        end

      end

    end

    describe "when the string contains more lines than the preview length" do

      before(:all) do
        @string = "a\nb\nc\nd\ne\nf\ng"
      end

      describe "and the text to match is in the first line" do

        it "should return the first lines limited to the preview length and end with the excluded content indicator" do
          @string.preview("a", 2).should eql("a\nb\nc\nd\ne\n...")
        end

      end

      describe "and the text to match is in a line in the middle" do

        describe "and lines at the start and end fall outside of the preview range" do

          it "should return the lines centered on the matching line limited to the preview length and surrounded by the excluded content indicator" do
            @string.preview("d", 2).should eql("...\nb\nc\nd\ne\nf\n...")
          end

        end

        describe "and the text to match falls on a line that does not preview lines at the end" do

          it "should return the lines centered on the matching line limited to the preview length and end with the excluded content indicator" do
            @string.preview("c", 2).should eql("a\nb\nc\nd\ne\n...")
          end

        end

        describe "and the text to match falls on a line that does not preview lines at the start" do

          it "should return the lines centered on the matching line limited to the preview length and start with the excluded content indicator" do
            @string.preview("e", 2).should eql("...\nc\nd\ne\nf\ng")
          end

        end

      end

      describe "and the text to match is in the last line" do

        it "should return the last lines limited to the preview length and start with the excluded content indicator" do
          @string.preview("g", 2).should eql("...\nc\nd\ne\nf\ng")
        end

      end

    end

    describe "when the string contains blank lines" do

      before(:all) do
        @string = "a\n\nb\nc"

      end

      it "should include the blank lines in the preview text but ignore them when determining surrounding lines" do
        @string.preview("b", 1).should eql(@string)
      end

    end

    it "should ignore casing when determining the matching line" do
      string = "a\nB\nc"
      string.preview("b", 1).should eql(string)
    end

  end

  context "#lpad_lines" do

    describe "when the string contains one line" do

      before(:all) do
        @string = "line"
      end

      describe "and the padding string is applied once" do

        it "should prefix the padding string to the start of the line" do
          @string.lpad_lines(1, "padding ").should eql("padding line")
        end

      end

      describe "and the padding string is applied multiple times" do

        it "should prefix the padding string the amount of time provided to the line" do
          @string.lpad_lines(3, "p ").should eql("p p p line")
        end

      end
      
    end

    describe "when the string contains multiple lines" do

      before(:all) do
        @string = "line 1\nline 2\nline 3"
      end

      describe "and the padding string is applied once" do

        it "should prefix the padding string to each line" do
          @string.lpad_lines(1, "padding ").should eql("padding line 1\npadding line 2\npadding line 3")
        end

      end

      describe "and the padding string is applied multiple times" do

        it "should prefix the padding string the amount of time provided to each line" do
          @string.lpad_lines(3, "p ").should eql("p p p line 1\np p p line 2\np p p line 3")
        end

      end

    end

    it "should not alter the string" do
      string = "some string"
      string.lpad_lines(1, "padding ")

      string.should eql("some string")
    end

  end

end
