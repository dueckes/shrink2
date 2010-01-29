describe IconsHelper do

  class TestableIconsHelper
    include IconsHelper
  end

  context "#icon" do

    before(:all) do
      @testable_icons_helper = TestableIconsHelper.new
    end

    describe "when provided an icon name" do

      it "should return an image tag" do
        @testable_icons_helper.should_receive(:image_tag).and_return("image tag")

        @testable_icons_helper.icon(:somename).should eql("image tag")
      end
      
      describe "that does not contain an underscore" do

        before(:each) do
          @name = :somename
        end

        it "should refer to an png image that appends the icon name to 'icon-'" do
          @testable_icons_helper.should_receive(:image_tag).with("icon-somename.png")

          @testable_icons_helper.icon(@name)
        end

      end

      describe "that contains an underscore" do

        before(:each) do
          @name = :some_name
        end

        it "should replace the underscore with a hypen in the png image name" do
          @testable_icons_helper.should_receive(:image_tag).with("icon-some-name.png")

          @testable_icons_helper.icon(@name)
        end

      end

    end

    describe "when provided with an icon name and color" do

      it "should refer to an png image that appends the icon name and color joint by a hypen to 'icon-'" do
        @testable_icons_helper.should_receive(:image_tag).with("icon-somename-somecolor.png")

        @testable_icons_helper.icon(:somename, :somecolor)
      end

    end

  end

end
