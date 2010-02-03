describe Shrink::ActiveRecord::OptionManipulation do

  class TestableOptionManipulation
    include Shrink::ActiveRecord::OptionManipulation
  end

  before(:each) do
    @option_manipulation = TestableOptionManipulation.new
  end

  context "#merge_options_including_conditions" do

    describe "when no options contain conditions" do

      before(:each) do
        @options1 = { :key1 => "value_1", :key2 => "value_2", :key3 => "value_3" }
        @options2 = { :key3 => "value_a", :key4 => "value_b", :key5 => "value_c" }
      end

      it "should merge the options with the first options taking priority" do
        merge_options_including_conditions.should eql({ :key1 => "value_1", :key2 => "value_2", :key3 => "value_3",
                                                        :key4 => "value_b", :key5 => "value_c" })
      end

    end

    describe "when one options contains conditions" do

      before(:each) do
        @options1 = { :conditions => ["Query"] }
        @options2 = {}
      end

      it "should return options including the condition" do
        merge_options_including_conditions[:conditions].should eql(["Query"])
      end

    end

    describe "when both options contain conditions" do

      before(:each) do
        @options1 = { :conditions => ["First query"] }
        @options2 = { :conditions => ["Second query"] }
      end

      it "should merge the conditions by delegating to #merge_conditions_including_values" do
        @option_manipulation.should_receive(:merge_conditions_including_values).with(
                @options1[:conditions], @options2[:conditions]).and_return(["Merged query"])

        merge_options_including_conditions[:conditions].should eql(["Merged query"])
      end

    end

    def merge_options_including_conditions
      @merged_options = @option_manipulation.merge_options_including_conditions(@options1, @options2)
    end

  end

  context "#merge_conditions_including_values" do

    describe "when the conditions contain queries with simple values to be substituted" do

      before(:each) do
        @merged_conditions = @option_manipulation.merge_conditions_including_values(
                ["first condition query", *create_array_of_simple_values(1)],
                ["second condition query", *create_array_of_simple_values(2)])
      end

      it "should merge the condition queries with an and clause enclosing the second query in brackets" do
        @merged_conditions.first.should eql("first condition query and (second condition query)")
      end

      it "should merge the condition values starting with values from the first condition" do
        @merged_conditions[1..-1].should eql(create_array_of_simple_values(1) + create_array_of_simple_values(2))

      end

    end

    describe "when the conditions contain an array value" do

      before(:each) do
        @merged_conditions = @option_manipulation.merge_conditions_including_values(
                ["first condition query", create_array_of_simple_values(1)],
                ["second condition query", create_array_of_simple_values(2)])
      end

      it "should return conditions containing the arrays as separate values" do
        @merged_conditions[1..-1].should eql([create_array_of_simple_values(1), create_array_of_simple_values(2)])
      end

    end

    def create_array_of_simple_values (condition_number)
      (1..3).collect { |i| "Value #{condition_number}.#{i}" }
    end

  end

end
