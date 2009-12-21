describe Array do

  context "#hasherize" do

    describe "when a block is provided that accepts each element as an argument" do

      before(:each) do
        @hash = [1, 2, 3].hasherize { |element| [element, "#{element}"] }
      end

      it "should convert the array to a hash" do
        @hash.should eql({ 1 => "1", 2 => "2", 3 => "3"})
      end

    end

    describe "when a block is provided that accepts each element and the elements position as an argument" do

      before(:each) do
        @hash = [3, 2, 1].hasherize { |element, position| [element, position] }
      end

      it "should convert the array to a hash" do
        @hash.should eql({ 3 => 0, 2 => 1, 1 => 2})
      end

    end

  end

  context "#collect_with_index" do

    it "should create an array composed of elements evaluated from a block accepting each element and the elements position" do
      [3, 2, 1].collect_with_index { |element, i| "#{element}#{i}" }.should eql(%w(30 21 12))
    end

  end
  
  context "#find_index" do

    it "should return the value provided as an argument when no element matches the block" do
      ["a", "b", "c"].find_index("z") { |element| element == "d" }.should eql("z")
    end

    it "should return nil when no value is provided as an argument and no element matches the block" do
      ["a", "b", "c"].find_index { |element| element == "d" }.should be_nil
    end

    it "should return the index of the matching element when an element matches the block" do
      ["a", "b", "c"].find_index { |element| element == "b" }.should eql(1)
    end

  end

  context "#preview" do

    describe "when the array contains the same number of elements as the preview length" do

      before(:each) do
        @array = %w(a b c)
      end

      describe "and the focus index is at the start of the array" do

        it "should return the entire array" do
          @array.preview(0, 3).should eql(@array)
        end

      end

      describe "and the focus index is in the middle of the array" do

        it "should return the entire array" do
          @array.preview(1, 3).should eql(@array)
        end

      end

      describe "and the focus index is at the end of the array" do

        it "should return the entire array" do
          @array.preview(2, 3).should eql(@array)
        end

      end

    end

    describe "when the array contains less elements than the preview length" do

      before(:each) do
        @array = %w(a b c)
      end

      describe "and the focus index is at the start of the array" do

        it "should return the entire array" do
          @array.preview(0, 5).should eql(@array)
        end

      end

      describe "and the focus index is in the middle of the array" do

        it "should return the entire array" do
          @array.preview(1, 5).should eql(@array)
        end

      end

      describe "and the focus index is at the end of the array" do

        it "should return the entire array" do
          @array.preview(2, 5).should eql(@array)
        end

      end

    end

    describe "when the array contains more elements than the preview length" do

      before(:each) do
        @array = %w(a b c d e)
      end

      describe "and the focus index is at the start of the array" do

        it "should return the first elements in the array limited to the preview length and end with the excluded content indicator" do
          @array.preview(0, 3, "...").should eql([@array[0..2], "..."].flatten)
        end

      end

      describe "and the focus index is in the middle of the array" do

        describe "and the focus index and the preview length omit elements at the start and end" do

          it "should return the elements centered on the focus index limited to the preview length surrounded by the excluded content indicator" do
            @array.preview(2, 3, "...").should eql(["...", @array[1..3], "..."].flatten)
          end

        end

        describe "and the focus index and the preview length only omit elements at the start" do

          it "should return the elements centered on the focus index limited to the preview length and end with the excluded content indicator" do
            @array.preview(1, 3, "...").should eql([@array[0..2], "..."].flatten)
          end

        end

        describe "and the focus index and the preview length only omit elements at the end" do

          it "should return the elements centered on the focus index limited to the preview length and start with the excluded content indicator" do
            @array.preview(3, 3, "...").should eql(["...", @array[2..4]].flatten)
          end

        end

      end

      describe "and the focus index is at the end of the array" do

        it "should return the last elements in the array limited to the preview length and start with the excluded content indicator" do
          @array.preview(4, 3).should eql(["...", @array[2..4]].flatten)
        end

      end

    end
    
  end
  
end
