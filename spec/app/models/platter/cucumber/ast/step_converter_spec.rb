describe Platter::Cucumber::Ast::StepConverter do

  class TestableStepConverter
    include Platter::Cucumber::Ast::StepConverter
  end

  context "#from" do

    before(:each) do
      @cucumber_ast_step = mock("Cucumber::Ast::Step",  :keyword => "", :name => "")
    end

    describe "creates a Platter::Step when provided a Cucumber::Ast::Step that" do

      it "should have text taken from the Cucumber::Ast::Step's keyword and name" do
        @cucumber_ast_step.stub!(:keyword => "Some Keyword")
        @cucumber_ast_step.stub!(:name => "Some Step Name")

        step = TestableStepConverter.from(@cucumber_ast_step)

        step.text.should eql("Some Keyword Some Step Name")
      end

    end

  end

end
