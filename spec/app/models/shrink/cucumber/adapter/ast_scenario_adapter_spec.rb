describe Shrink::Cucumber::Adapter::AstScenarioAdapter do

  class TestableAstScenarioAdapter
    include Shrink::Cucumber::Adapter::AstScenarioAdapter
  end

  context "#adapt" do

    before(:each) do
      @cucumber_ast_scenario = mock("Cucumber::Ast::Scenario",  :name => "", :steps => [])
      @step_adapter = mock("Shrink::Cucumber::Adapter::AstStepAdapter", :null_object => true)
      TestableAstScenarioAdapter.set_step_adapter(@step_adapter)
    end

    describe "creates a Shrink::Scenario when provided a Cucumber::Ast::Scenario that" do

      it "should have a title taken from the Cucumber::Ast::Scenario's name" do
        @cucumber_ast_scenario.stub!(:name => "Some Scenario Name")

        scenario = TestableAstScenarioAdapter.adapt(@cucumber_ast_scenario)

        scenario.title.should eql("Some Scenario Name")
      end

      it "should have steps created via the configured step adapter" do
        cucumber_ast_steps = []
        all_steps = []
        (1..3).each do |i|
          cucumber_ast_steps << cucumber_ast_step = mock("Cucumber::Ast::Step")
          all_steps.concat(steps = (1..3).collect { |j| Shrink::Step.new(:text => "Text #{i}.#{j}") })
          @step_adapter.should_receive(:adapt).with(cucumber_ast_step).and_return(steps)
        end
        @cucumber_ast_scenario.stub!(:steps => cucumber_ast_steps)

        scenario = TestableAstScenarioAdapter.adapt(@cucumber_ast_scenario)

        scenario.steps.should eql(all_steps)
      end

    end

  end

end
