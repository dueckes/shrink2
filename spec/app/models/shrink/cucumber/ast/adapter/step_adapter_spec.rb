describe Shrink::Cucumber::Ast::Adapter::StepAdapter do

  class TestableAstStepAdapter
    include Shrink::Cucumber::Ast::Adapter::StepAdapter
  end

  context "#adapt" do

    before(:each) do
      @table_adapter = mock("TableAdapter").as_null_object
      TestableAstStepAdapter.set_table_adapter(@table_adapter)
    end

    describe "when the Cucumber::Ast::Step contains a keyword and name prefixed with whitespace" do

      before(:each) do
        @cucumber_ast_step = mock(Cucumber::Ast::Step, :keyword => "Some Keyword", :name => " Some Name")
      end

      describe "and no multi-line argument" do

        before(:each) do
          @cucumber_ast_step.stub!(:multiline_arg).and_return(nil)
          @steps = TestableAstStepAdapter.adapt(@cucumber_ast_step)
        end

        it "should return an array with one Shrink::Step" do
          @steps.should have(1).step
        end

        it "should return a Shrink::Step with text combining the keyword and name" do
          @steps.first.text.should eql("Some Keyword Some Name")
        end

      end

      describe "and a multi-line argument" do

        describe "that is a Cucumber::Ast::Table" do

          before(:each) do
            @cucumber_table = mock(::Cucumber::Ast::Table)
            @cucumber_table.stub!(:is_a?).and_return(false)
            @cucumber_table.stub!(:is_a?).with(::Cucumber::Ast::Table).and_return(true)
            @cucumber_ast_step.stub!(:multiline_arg).and_return(@cucumber_table)
          end

          it "should create a Shrink::Table via the configured table adapter" do
            @table_adapter.should_receive(:adapt).with(@cucumber_table).and_return(Shrink::Table.new)

            TestableAstStepAdapter.adapt(@cucumber_ast_step)
          end

          it "should return a Shrink::Step for the keyword and name and an additional Shrink::Step for the table" do
            table = Shrink::Table.new
            @table_adapter.stub!(:adapt).and_return(table)

            steps = TestableAstStepAdapter.adapt(@cucumber_ast_step)

            steps.should have(2).steps
            steps.first.text.should eql("Some Keyword Some Name")
            steps.first.table.should be_nil
            steps.second.text.should be_nil
            steps.second.table.should eql(table)
          end

        end

        describe "that is not a Cucumber::Ast::Table" do

          before(:each) do
            cucumber_table = mock("SomeMultilineArgument")
            cucumber_table.stub!(:is_a?).and_return(false)
            @cucumber_ast_step.stub!(:multiline_arg).and_return(cucumber_table)
            
            @steps = TestableAstStepAdapter.adapt(@cucumber_ast_step)
          end

          it "should return an array with one Shrink::Step with text containing the keyword and name" do
            @steps.should have(1).step

            @steps.first.text.should eql("Some Keyword Some Name")
          end

        end

      end

    end

  end

end
