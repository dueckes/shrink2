describe Platter::Cucumber::Ast::ScenarioConverter do

  class TestableScenarioConverter
    include Platter::Cucumber::Ast::ScenarioConverter
  end

  context "#from" do

    before(:each) do
      @cucumber_ast_scenario = mock("Cucumber::Ast::Scenario",  :name => "", :steps => [])
      @step_converter = mock("Platter::Cucumber::Ast::StepConverter", :null_object => true)
      TestableScenarioConverter.set_step_converter(@step_converter)
    end

    describe "creates a Platter::Scenario when provided a Cucumber::Ast::Scenario that" do

      it "should have a title taken from the Cucumber::Ast::Scenario's name" do
        @cucumber_ast_scenario.stub!(:name => "Some Scenario Name")

        scenario = TestableScenarioConverter.from(@cucumber_ast_scenario)

        scenario.title.should eql("Some Scenario Name")
      end

      it "should have steps created via the configured step converter" do
        cucumber_ast_steps = []
        steps = []
        (1..3).each do |i|
          cucumber_ast_steps << cucumber_ast_step = mock("Cucumber::Ast::Step")
          steps << step = Platter::Step.new(:text => "Text#{i}")
          @step_converter.should_receive(:from).with(cucumber_ast_step).and_return(step)
        end
        @cucumber_ast_scenario.stub!(:steps => cucumber_ast_steps)

        scenario = TestableScenarioConverter.from(@cucumber_ast_scenario)

        scenario.steps.should eql(steps)
      end

    end

  end

end
