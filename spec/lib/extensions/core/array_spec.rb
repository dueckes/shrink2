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

end
