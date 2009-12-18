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

      it "should return the string unaltered" do
        "String with_underscores-Hypens and spaces 1".fileize.should eql("String with_underscores-Hypens and spaces 1")
      end

    end

    describe "when a string contains characters other than alphanumerics, underscores, hypens and whitespace" do

      it "should return remove the non-alphanumerics, underscores, hypens and whitespace characters" do
        'String!@#$%+)(*&^"'.fileize.should eql("String")
      end

    end

    describe "when the string is surrounded by whitespace" do

      it "should return a string with the surrounding whitespace removed" do
        " some string ".fileize.should eql("some string")
      end

    end

  end

end
