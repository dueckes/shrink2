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

end
