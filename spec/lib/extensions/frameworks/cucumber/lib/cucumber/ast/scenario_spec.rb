describe Cucumber::Ast::Scenario do

  context "#tag_names" do

    before(:each) do
      @tag_names = (1..3).collect { |i| "@tag_#{i}" }
      @scenario = Cucumber::Ast::Scenario.new(
              nil, nil, mock("Cucumber::Ast::Tags", :tag_names => @tag_names), nil, nil, nil, nil)
    end

    it "should retrieve the tag names from the tags" do
      @scenario.tag_names.should eql(@tag_names)
    end

  end

end
