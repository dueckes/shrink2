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

    describe "when a string contains only alphanumeric characters" do

      it "should return the string unaltered" do
        "some_string".fileize.should eql("some_string")
      end

    end

    describe "when a string contains spaces" do

      it "should return the string with spaces replaced by underscores" do
        "string with spaces".fileize.should eql("string_with_spaces")
      end

    end

    describe "when a string contains mixed casing" do

      it "should return the string in lowercase" do
        "StringWithMixedCase".fileize.should eql("stringwithmixedcase")
      end

    end

    describe "when a string contains non-alphanumeric characters" do

      it "should return the string without non-alphanumeric characters" do
        'T1tle !@#$%with n0n alph4 numeric +)(*&^characters and numb3rs'.fileize.should eql(
                "t1tle_with_n0n_alph4_numeric_characters_and_numb3rs")
      end

    end

  end

end
