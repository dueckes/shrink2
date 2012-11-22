describe Cucumber::Ast::Scenario do

  context "#tag_names" do

    let(:tag_names) do
      (1..3).collect { |i| "@tag_#{i}" }
    end
    let(:tags) { mock(Cucumber::Ast::Tags, :names => tag_names) }
    let(:scenario) { Cucumber::Ast::Scenario.new(nil, nil, tags, nil, nil, nil, nil, nil) }

    it "should retrieve the tag names from the tags" do
      scenario.tag_names.should eql(tag_names)
    end

  end

end
