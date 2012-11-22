describe Shrink::DeclarativeAuthorization::ActionPack::ActionView::Base do

  describe Shrink::DeclarativeAuthorization::ActionPack::ActionView::Base::ClassMethods do

    class TestableBaseClassMethods
      extend Shrink::DeclarativeAuthorization::ActionPack::ActionView::Base::ClassMethods

      def method_with_no_args
      end

      def method_with_args(arg1, arg2, arg3)
      end

      def method_with_block(&block)
      end

      def method1
      end

      def method2
      end

      def method3
      end

    end

    context "#add_declarative_authorization_support_to" do

      describe "when the name of a method accepting no arguments is provided" do

        before(:all) do
          add_declarative_authorization_support_to(:method_with_no_args)
        end

        it "should delegate to #invoke_with_declarative_authorization_support when that method is invoked" do
          @testable_instance.should_receive(:invoke_with_declarative_authorization_support).with(
                  :method_with_no_args_without_declarative_authorization_support)

          @testable_instance.method_with_no_args
        end

      end

      describe "when the name of a method accepting arguments is provided" do

        before(:all) do
          add_declarative_authorization_support_to(:method_with_args)
        end

        it "should delegate to #invoke_with_declarative_authorization_support supplying the arguments when that method is invoked" do
          @testable_instance.should_receive(:invoke_with_declarative_authorization_support).with(
                  :method_with_args_without_declarative_authorization_support, 1, 3, 5)

          @testable_instance.method_with_args(1, 3, 5)
        end

      end

      describe "when the name of a method accepting a block is provided" do

        before(:all) do
          add_declarative_authorization_support_to(:method_with_block)
        end

        it "should delegate to #invoke_with_declarative_authorization_support supplying the block when that method is invoked" do
          block = Proc.new { "Some block" }

          @testable_instance.should_receive(:invoke_with_declarative_authorization_support).with(
                  :method_with_block_without_declarative_authorization_support, &block)

          @testable_instance.method_with_block(&block)
        end

      end

      describe "when a number of methods are provided" do

        before(:each) do
          @methods = (1..3).collect { |i| "method#{i}".to_sym }
          add_declarative_authorization_support_to(*@methods)
        end

        it "should alias each method with declarative authorization support" do
          @methods.each do |method|
            @testable_instance.should respond_to("#{method}_without_declarative_authorization_support".to_sym)
          end
        end

      end

      def add_declarative_authorization_support_to(*methods)
        TestableBaseClassMethods.add_declarative_authorization_support_to(*methods)
        @testable_instance = TestableBaseClassMethods.new
      end

    end

  end

  describe Shrink::DeclarativeAuthorization::ActionPack::ActionView::Base::InstanceMethods do

    class TestableBaseInstanceMethods
      include Shrink::DeclarativeAuthorization::ActionPack::ActionView::Base::InstanceMethods

      def method_with_args_and_block(arg1, arg2, arg3, &block)
      end

    end

    before(:each) do
      @testable_instance = TestableBaseInstanceMethods.new
      @testable_instance.stub!(:permitted_to?)
    end

    context "#invoke_with_declarative_authorization_support" do

      before(:each) do
        @args = [1, 3, 5]
        @block = Proc.new { "Some block" }
      end

      describe "when the arguments of the method conclude with a hash containing a :when_permitted_to key" do

        before(:each) do
          @args << { :when_permitted_to => [:privilege, :object] }
        end

        it "should invoke #permitted_to with the value provided in the hash entry" do
          @testable_instance.should_receive(:permitted_to?).with(:privilege, :object)

          invoke_with_declarative_authorization_support
        end

        describe "when permitted_to returns true" do

          before(:each) do
            @testable_instance.stub!(:permitted_to?).and_return(true)
          end

          it "should delegate to and return the result from the method providing arguments and any block provided" do
            @testable_instance.should_receive(:method_with_args_and_block).with(1, 3, 5, &@block).and_return("Result")

            invoke_with_declarative_authorization_support.should eql("Result")
          end

        end

        describe "when permitted_to returns false" do

          before(:each) do
            @testable_instance.stub!(:permitted_to?).and_return(false)
          end

          describe "and the hash contains an :otherwise key" do

            before(:each) do
              @args.last[:otherwise] = "Alternate Result"
            end

            it "should return the value provided in the hash entry" do
              invoke_with_declarative_authorization_support.should eql("Alternate Result")
            end

            it "should return a html safe value" do
              invoke_with_declarative_authorization_support.should be_html_safe
            end

          end

          describe "and the hash does not contain an :otherwise key" do

            it "should return an empty string" do
              invoke_with_declarative_authorization_support.should be_an_empty_string
            end

            it "should return a html safe string" do
              invoke_with_declarative_authorization_support.should be_html_safe
            end


          end

        end

      end

      describe "when the arguments of the method do not conclude with a hash containing a :when_permitted_to key" do

        it "should delegate to and return the result from the method preserving arguments and any block provided" do
          @testable_instance.should_receive(:method_with_args_and_block).with(*@args, &@block).and_return("Result")

          invoke_with_declarative_authorization_support.should eql("Result")
        end

      end

      def invoke_with_declarative_authorization_support
        @testable_instance.invoke_with_declarative_authorization_support(:method_with_args_and_block, *@args, &@block)
      end

    end

  end

end
