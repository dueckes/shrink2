describe Platter::Cucumber::Adapter::AstFeatureAdapter do

  class TestableAstFeatureAdapter
    include Platter::Cucumber::Adapter::AstFeatureAdapter
  end

  context "#adapt" do

    before(:each) do
      @cucumber_ast_feature = mock("Cucumber::Ast::Feature", :feature_elements => [])
      @feature_parser = mock("Platter::Cucumber::Adapter::AstFeatureParser", :tag_names => [], :title => "", :lines_text => [])
      Platter::Cucumber::Adapter::AstFeatureParser.stub!(:new).with(@cucumber_ast_feature).and_return(@feature_parser)

      @scenario_adapter = mock("Platter::Cucumber::Adapter::AstScenarioAdapter", :null_object => true)
      TestableAstFeatureAdapter.set_scenario_adapter(@scenario_adapter)
    end

    describe "creates a Platter::Feature when provided a Cucumber::Ast::Feature that" do
      
      it "should have tags whose names are retrieved from the Platter::Cucumber::Ast::FeatureParser" do
        tag_names = (1..3).collect { |i| "tag_#{i}" }
        @feature_parser.stub!(:tag_names => tag_names)
        tags = tag_names.collect do |tag_name|
          tag = Platter::Tag.new(:name => tag_name)
          Platter::Tag.should_receive(:find_or_create!).with(:name => tag_name).and_return(tag)
          tag
        end
        @feature = TestableAstFeatureAdapter.adapt(@cucumber_ast_feature)

        @feature.tags.should eql(tags)
      end

      it "should have a title retrieved from the Platter::Cucumber::Adapter::AstFeatureParser" do
        @feature_parser.stub!(:title => "Some Feature Title")

        @feature = TestableAstFeatureAdapter.adapt(@cucumber_ast_feature)

        @feature.title.should eql("Some Feature Title")
      end

      it "should have lines retrieved from the Platter::Cucumber::Adapter::AstFeatureParser" do
        lines_text = ["First Line Text", "Second Line Text", "Third Line Text"]
        @feature_parser.stub!(:lines_text => lines_text)

        @feature = TestableAstFeatureAdapter.adapt(@cucumber_ast_feature)

        @feature.lines.each_with_index do |line, i|
          line.should be_a(Platter::FeatureLine)
          line.text.should eql(lines_text[i])
        end
      end

      it "should have scenarios created from the Cucumber::Ast::Feature's feature elements via the configured scenario adapter" do
        cucumber_ast_scenarios = []
        scenarios = []
        (1..3).each do |i|
          cucumber_ast_scenarios << cucumber_ast_scenario = mock("Cucumber::Ast::Scenario")
          scenarios << feature = Platter::Scenario.new(:title => "Title#{i}")
          @scenario_adapter.should_receive(:adapt).with(cucumber_ast_scenario).and_return(feature)
        end
        @cucumber_ast_feature.stub!(:feature_elements => cucumber_ast_scenarios)

        feature = TestableAstFeatureAdapter.adapt(@cucumber_ast_feature)

        feature.scenarios.should eql(scenarios)
      end

    end

  end

end
