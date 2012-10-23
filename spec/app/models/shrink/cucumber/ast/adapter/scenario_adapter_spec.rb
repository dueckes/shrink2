describe Shrink::Cucumber::Ast::Adapter::ScenarioAdapter do

  class TestableAstScenarioAdapter
    include Shrink::Cucumber::Ast::Adapter::ScenarioAdapter
  end

  context "#adapt" do

    before(:each) do
      @cucumber_ast_scenario = mock("Cucumber::Ast::Scenario",  :name => "", :steps => [], :tag_names => [])
      @step_adapter = mock("Shrink::Cucumber::Ast::Adapter::StepAdapter", :null_object => true)
      TestableAstScenarioAdapter.set_step_adapter(@step_adapter)
      @tag_adapter = mock("Shrink::Cucumber::Ast::Adapter::TagAdapter", :null_object => true)
      TestableAstScenarioAdapter.set_tag_adapter(@tag_adapter)
    end

    describe "creates a Shrink::Scenario when provided a Cucumber::Ast::Scenario that" do

      it "should have tags created via the TagAdapter using tag names retrieved from the Cucumber::Ast::Scenario" do
        tag_names = (1..3).collect { |i| "@tag_#{i}" }
        @cucumber_ast_scenario.stub(:tag_names => tag_names)
        tags = tag_names.collect_with_index do |tag_name, i|
          tag = Shrink::Tag.new(:name => "tag_#{i}")
          @tag_adapter.should_receive(:adapt).with(tag_name).and_return(tag)
          tag
        end

        to_scenario

        @scenario.tags.should eql(tags)
      end

      it "should have a title taken from the Cucumber::Ast::Scenario's name" do
        @cucumber_ast_scenario.stub!(:name => "Some Scenario Name")

        to_scenario

        @scenario.title.should eql("Some Scenario Name")
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

        to_scenario

        @scenario.steps.should eql(all_steps)
      end

    end

    def to_scenario
      @scenario = TestableAstScenarioAdapter.adapt(@cucumber_ast_scenario)
    end

  end

end
