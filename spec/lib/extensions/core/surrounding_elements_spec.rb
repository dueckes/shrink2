describe SurroundingElements do

  before(:all) do
    @array_empty = []
    @array_with_one_element = %w(a)
    @array_with_multiple_elements = %w(a b c d e f g)
  end

  context "#new" do

    describe "when the array is empty" do

    it "should raise an error" do
        lambda { SurroundingElements.new(@array_empty, "a", 1) }.should raise_error
      end

    end

    describe "when the length is 0" do

      it "should return nil" do
        lambda { SurroundingElements.new(@array_with_multiple_elements, "a", 0) }.should raise_error
      end

    end

    describe "when the length is less than 0" do

      it "should raise an error" do
        lambda { SurroundingElements.new(@array_with_multiple_elements, "a", -1) }.should raise_error
      end

    end

    describe "when the center element does not exist" do

      it "should raise an error" do
        lambda { SurroundingElements.new(@array_with_multiple_elements, "z", 1) }.should raise_error
      end

    end

  end

  context "#first" do

    describe "when the array is not empty" do

      describe "and the length is greater than 0" do

        describe "and the center element exists" do

          describe "and the array contains multiple elements" do

            before(:all) do
              @array = @array_with_multiple_elements
            end

            describe "and the center element is at the start" do

              it "should return the first element" do
                SurroundingElements.new(@array, "a", 1).first.should eql(@array.first)
              end

            end

            describe "and the center elements position leaves less elements than the length until the start" do

              it "should return the first element" do
                SurroundingElements.new(@array, "b", 2).first.should eql(@array.first)
              end

            end

            describe "and the center elements position leaves at least length elements until the start" do

              it "should return the element at the index minus the length" do
                SurroundingElements.new(@array, "c", 1).first.should eql("b")
              end

            end

            describe "and the center elements position leaves less elements than the length until the end" do

              describe "and the total surrounding elements length is less than the array length" do

                it "should return the element at the last position minus the surrounding elements length" do
                  SurroundingElements.new(@array, "f", 2).first.should eql("c")
                end

              end

              describe "and the total surrounding elements length is greater than the array length" do

                it "should return the first element" do
                  SurroundingElements.new(@array, "d", 4).first.should eql(@array.first)
                end

              end

            end

            describe "and the center elements position is at the end" do

              it "should return the element at the last position minus the surrounding elements length" do
                SurroundingElements.new(@array, "g", 1).first.should eql("e")
              end

            end

          end

          describe "and the array contains one element" do

            before(:all) do
              @array = @array_with_one_element
            end

            it "should return the element" do
              SurroundingElements.new(@array, "a", 2).first.should eql("a")
            end

          end

        end

      end

    end

  end

  context "#last" do

    describe "when the array is not empty" do

      describe "and the length is greater than 0" do

        describe "and the center element exists" do

          describe "and the array contains multiple elements" do

            before(:all) do
              @array = @array_with_multiple_elements
            end

            describe "and the center elements position is at the end" do

              it "should return the last element" do
                SurroundingElements.new(@array, "g", 1).last.should eql(@array.last)
              end

            end

            describe "and the center elements position leaves less elements than the length until the end" do

              it "should return the last element" do
                SurroundingElements.new(@array, "f", 2).last.should eql(@array.last)
              end

            end

            describe "and the center elements position leaves at least length elements until the start" do

              it "should return the element at the center elements position plus the length" do
                SurroundingElements.new(@array, "d", 1).last.should eql("e")
              end

            end

            describe "and the center elements position leaves less elements than the length until the start" do

              describe "and the total surrounding elements length is less than the array length" do

                it "should return the element at the first position plus the surrounding elements length" do
                  SurroundingElements.new(@array, "b", 2).last.should eql("e")
                end

              end

              describe "and the total surrounding elements length is greater than the array length" do

                it "should return the last element" do
                  SurroundingElements.new(@array, "d", 4).last.should eql(@array.last)
                end

              end

            end

            describe "and the center elements position is at the start" do

              it "should return the element at the first position plus the surrounding elements length" do
                SurroundingElements.new(@array, "a", 2).last.should eql("e")
              end

            end

          end

          describe "and the array contains one element" do

            before(:all) do
              @array = @array_with_one_element
            end

            it "should return the element" do
              SurroundingElements.new(@array, "a", 2).last.should eql("a")
            end

          end

        end

      end

    end

  end

end
