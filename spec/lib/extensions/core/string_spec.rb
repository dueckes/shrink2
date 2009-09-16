describe String do

  context "#as_directory_names" do

    describe "when the string is empty" do

      before(:each) do
        @string = ""
      end

      it "should return an array containing an empty string" do
        @string.as_directory_names.should eql([@string])
      end

    end

    describe "when the string contains a single directory name" do

      before(:each) do
        @string = "directory"
      end

      it "should return an array containing the directory name" do
        @string.as_directory_names.should eql([@string])
      end

    end

    describe "when the string starts and ends in a path seperator" do

      before(:each) do
        @string = "/directory/"
      end

      it "should return an array containing the string without the seperators" do
        @string.as_directory_names.should eql(["directory"])
      end

    end

    describe "when the string contains a directory structure" do

      before(:each) do
        @string = "first/second/third"
      end

      it "should return the names of the directories in order of appearance in the string" do
        @string.as_directory_names.should eql(%w(first second third))
      end

    end

  end

end
