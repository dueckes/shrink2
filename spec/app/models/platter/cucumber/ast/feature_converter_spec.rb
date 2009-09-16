describe Platter::Cucumber::Ast::FeatureConverter do

  class TestableFeatureConverter
    include Platter::Cucumber::Ast::FeatureConverter
  end

  context "#from" do

    before(:each) do
      @cucumber_ast_feature = mock("Cucumber::Ast::Feature", :feature_elements => [])
      @feature_parser = mock("Platter::Cucumber::Ast::FeatureParser", :title => "", :lines_text => [])
      Platter::Cucumber::Ast::FeatureParser.stub!(:new).with(@cucumber_ast_feature).and_return(@feature_parser)

      @scenario_converter = mock("Platter::Cucumber::Ast::ScenarioConverter", :null_object => true)
      TestableFeatureConverter.set_scenario_converter(@scenario_converter)
    end

    describe "creates a Platter::Feature when provided a Cucumber::Ast::Feature that" do
      
      it "should have a title retrieved from the Platter::Cucumber::Ast::FeatureParser" do
        @feature_parser.stub!(:title => "Some Feature Title")

        @feature = TestableFeatureConverter.from(@cucumber_ast_feature)

        @feature.title.should eql("Some Feature Title")
      end

      it "should have lines retrieved from the Platter::Cucumber::Ast::FeatureParser" do
        lines_text = ["First Line Text", "Second Line Text", "Third Line Text"]
        @feature_parser.stub!(:lines_text => lines_text)

        @feature = TestableFeatureConverter.from(@cucumber_ast_feature)

        @feature.lines.each_with_index do |line, i|
          line.should be_a(Platter::FeatureLine)
          line.text.should eql(lines_text[i])
        end
      end

      it "should have scenarios created from the Cucumber::Ast::Feature's feature elements via the configured scenario converter" do
        cucumber_ast_scenarios = []
        scenarios = []
        (1..3).each do |i|
          cucumber_ast_scenarios << cucumber_ast_scenario = mock("Cucumber::Ast::Scenario")
          scenarios << feature = Platter::Scenario.new(:title => "Title#{i}")
          @scenario_converter.should_receive(:from).with(cucumber_ast_scenario).and_return(feature)
        end
        @cucumber_ast_feature.stub!(:feature_elements => cucumber_ast_scenarios)

        feature = TestableFeatureConverter.from(@cucumber_ast_feature)

        feature.scenarios.should eql(scenarios)
      end

    end

  end

end
