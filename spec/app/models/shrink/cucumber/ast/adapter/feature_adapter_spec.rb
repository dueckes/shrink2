describe Shrink::Cucumber::Ast::Adapter::FeatureAdapter do

  class TestableAstFeatureAdapter
    include Shrink::Cucumber::Ast::Adapter::FeatureAdapter
  end

  context "#adapt" do

    before(:each) do
      @cucumber_ast_feature = mock("Cucumber::Ast::Feature", :feature_elements => [])
      @feature_parser = mock("Shrink::Cucumber::Ast::FeatureParser", :raw_tag_names => [], :title => "", :text_lines => [])
      Shrink::Cucumber::Ast::FeatureParser.stub!(:new).with(@cucumber_ast_feature).and_return(@feature_parser)

      @scenario_adapter = mock("Shrink::Cucumber::Ast::Adapter::ScenarioAdapter", :null_object => true)
      TestableAstFeatureAdapter.set_scenario_adapter(@scenario_adapter)
      @tag_adapter = mock("Shrink::Cucumber::Ast::Adapter::TagAdapter")
      TestableAstFeatureAdapter.set_tag_adapter(@tag_adapter)
    end

    describe "creates a Shrink::Feature when provided a Cucumber::Ast::Feature that" do
      
      it "should have tags created via the TagAdapter using raw tag names retrieved from the FeatureParser" do
        raw_tag_names = (1..3).collect { |i| "@tag_#{i}" }
        @feature_parser.stub!(:raw_tag_names => raw_tag_names)
        tags = raw_tag_names.collect_with_index do |raw_tag_name, i|
          tag = Shrink::Tag.new(:name => "tag_#{i}")
          @tag_adapter.should_receive(:adapt).with(raw_tag_name).and_return(tag)
          tag
        end

        to_feature

        @feature.tags.should eql(tags)
      end

      it "should have a title retrieved from the Shrink::Cucumber::Ast::FeatureParser" do
        @feature_parser.stub!(:title => "Some Feature Title")

        to_feature

        @feature.title.should eql("Some Feature Title")
      end

      it "should have description lines retrieved from the Shrink::Cucumber::Ast::FeatureParser" do
        text_lines = ["First Line Text", "Second Line Text", "Third Line Text"]
        @feature_parser.stub!(:text_lines => text_lines)

        to_feature

        @feature.description_lines.each_with_index do |description_line, i|
          description_line.should be_a(Shrink::FeatureDescriptionLine)
          description_line.text.should eql(text_lines[i])
        end
      end

      it "should have scenarios created from the Cucumber::Ast::Feature's feature elements via the configured scenario adapter" do
        cucumber_ast_scenarios = []
        scenarios = []
        (1..3).each do |i|
          cucumber_ast_scenarios << cucumber_ast_scenario = mock("Cucumber::Ast::Scenario")
          scenarios << feature = Shrink::Scenario.new(:title => "Title#{i}")
          @scenario_adapter.should_receive(:adapt).with(cucumber_ast_scenario).and_return(feature)
        end
        @cucumber_ast_feature.stub!(:feature_elements => cucumber_ast_scenarios)

        to_feature

        @feature.scenarios.should eql(scenarios)
      end

    end

    def to_feature
      @feature = TestableAstFeatureAdapter.adapt(@cucumber_ast_feature)
    end

  end

end
