describe Platter::Cucumber::Ast::FeatureParser do

  context "#tag_names" do

    describe "when source_tag_names are in the Cucumber::Ast::Feature" do

      before(:each) do
        source_tag_names = (1..3).collect { |i| "@tag_#{i}" }
        cucumber_ast_feature = mock("Cucumber::Ast::Feature", :source_tag_names => source_tag_names)
        @feature_parser = Platter::Cucumber::Ast::FeatureParser.new(cucumber_ast_feature)
      end

      it "should return the source_tag_names with leading '@' characters removed from the Cucumber::Ast::Feature" do
        @feature_parser.tag_names.should eql((1..3).collect { |i| "tag_#{i}" })
      end

    end

  end

  context "#title" do

    describe "when the first line in the Cucumber::Ast::Feature contains a colon-delimited prefix" do

      before(:each) do
        @feature_parser = create_parser_for("Feature: Some Title Text")
      end

      it "should return the text following the colon" do
        @feature_parser.title.should eql("Some Title Text")
      end

    end

    describe "when the first line in the Cucumber::Ast::Feature does not contain a colon-delimited prefix" do

      before(:each) do
        @feature_parser = create_parser_for("Some Title Text")
      end

      it "should return the entire first line" do
        @feature_parser.title.should eql("Some Title Text")
      end

    end

  end

  context "#lines_text" do

    describe "when there is only one line in the Cucumber::Ast::Feature" do

      before(:each) do
        @feature_parser = create_parser_for("Some Title Text")
      end

      it "should return an empty array" do
        @feature_parser.lines_text.should be_empty
      end

    end

    describe "when there is more than one line in the Cucumber::Ast::Feature" do

      before(:each) do
        @feature_parser = create_parser_for <<-FEATURE_NAME
        Feature: Some Title Text
          First Line Text
          Second Line Text
          Third Line Text
        FEATURE_NAME
      end

      it "should return the text for each line after the first" do
        expected_feature_lines = []
        @feature_parser.lines_text.should eql(["First Line Text", "Second Line Text", "Third Line Text"])
      end

    end

  end

  def create_parser_for(cucumber_ast_feature_name)
    cucumber_ast_feature = mock("Cucumber::Ast::Feature", :name => cucumber_ast_feature_name)
    Platter::Cucumber::Ast::FeatureParser.new(cucumber_ast_feature)
  end

end
