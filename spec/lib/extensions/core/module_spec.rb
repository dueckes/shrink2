describe Module do

  context "#contextless_name" do

    describe "when the module is not nested within another module" do

      before(:all) do
        module SomeModule
        end
      end

      it "should return the name of the module" do
        SomeModule.contextless_name.should eql("SomeModule")
      end

    end

    describe "when the module is nested within another module" do

      before(:all) do                                                    \
        module OuterModule
          module InnerModule
          end
        end
      end

      it "should return only the name of the module" do
        OuterModule::InnerModule.contextless_name.should eql("InnerModule")
      end

    end

  end

  context "#mandatory_cattr_accessor" do

    describe "when a mandatory accessor named 'some_accessor' has been added to the class" do

      before(:each) do
        @class_with_mandatory_accessor = Class.new
        @class_with_mandatory_accessor.mandatory_cattr_accessor :some_accessor
      end

      context "#some_accessor" do

        describe "when a value has been established" do

          before(:each) do
            @class_with_mandatory_accessor.set_some_accessor("some value")
          end

          it "should return the value" do
            @class_with_mandatory_accessor.some_accessor.should eql("some value")
          end

        end

        describe "when a value has not been established" do

          it "should raise an exception" do
            lambda { @class_with_mandatory_accessor.some_accessor }.should raise_error
          end

        end

      end

      context "#set_some_accessor" do

        describe "when the value provided is not nil" do

          it "should not raise an error" do
            @class_with_mandatory_accessor.set_some_accessor("some value")
          end
          
        end

        describe "when the value provided is nil" do

          it "should raise an exception" do
            lambda { @class_with_mandatory_accessor.set_some_accessor(nil) }.should raise_error
          end

        end

      end

    end

  end

end
