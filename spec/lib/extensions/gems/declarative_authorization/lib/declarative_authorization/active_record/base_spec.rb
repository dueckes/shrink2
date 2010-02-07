describe Shrink::DeclarativeAuthorization::ActiveRecord::Base do

  describe "when included in a class" do

    class TestableBaseClass
      include Shrink::DeclarativeAuthorization::ActiveRecord::Base
    end

    context "#decl_auth_context" do

      before(:each) do
        @tableized_name = mock("TableizedName", :null_object => true)
        @contextless_name = mock("ContextlessName", :tableize => @tableized_name, :null_object => true)
        TestableBaseClass.stub!(:contextless_name).and_return(@contextless_name)
      end

      it "should use the contextless name of the class" do
        TestableBaseClass.should_receive(:contextless_name)

        TestableBaseClass.decl_auth_context
      end

      it "should tableize the contextless name" do
        @contextless_name.should_receive(:tableize)

        TestableBaseClass.decl_auth_context
      end

      it "should return a symbolized version of the tableized contextless name" do
        @tableized_name.should_receive(:to_sym).and_return(:result)

        TestableBaseClass.decl_auth_context.should eql(:result)
      end

    end
  end
end
