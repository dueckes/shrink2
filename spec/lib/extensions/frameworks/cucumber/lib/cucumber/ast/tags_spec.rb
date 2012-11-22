describe Cucumber::Ast::Tags do

  context "#names" do

    let(:tag_names) do
      (1..3).collect { |i| "@tag_#{i}" }
    end
    let(:tag_array) do
      tag_names.collect { |tag_name| mock("Tag", :name => tag_name) }
    end
    let(:tags) { Cucumber::Ast::Tags.new(nil, tag_array) }

    it "should retrieve the names from the tags" do
      tags.names.should eql(tag_names)
    end

  end

end
