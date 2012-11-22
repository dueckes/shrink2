describe Shrink::Tag do

  describe "integrating with the database" do
    include_context "database integration"
    include_context "clear database after each"

    before(:each) do
      @project = create_project!(:name => "Some Project")
      @other_project = create_project!(:name => "Another Project")
    end

    context "#features" do

      before(:each) do
        @tag = create_tag!
      end

      describe "when features have been added" do

        before(:each) do
          %w(a_title z_title m_title).each do |feature_title|
            @tag.features << create_feature!(:title => feature_title)
          end
        end

        it "should contain the features that have been added ordered alphanumerically" do
          @tag.should have(3).features
          @tag.features.collect(&:title).should include("a_title", "m_title", "z_title")
        end

      end

    end

    context "#scenarios" do

      before(:each) do
        @tag = create_tag!
      end

      describe "when scenarios have been added" do

        before(:each) do
          %w(a_title z_title m_title).each do |scenario_title|
            @tag.scenarios << create_scenario!(:title => scenario_title)
          end
        end

        it "should contain the scenarios that have been added ordered alphanumerically" do
          @tag.should have(3).scenarios
          @tag.scenarios.collect(&:title).should include("a_title", "m_title", "z_title")
        end

      end

    end

    context "#valid?" do

      before(:each) do
        @tag = Shrink::Tag.new(:project => @project, :name => "Some Name")
      end

      describe "when a project and name has been established" do

        describe "and no other tag in the project has the same name" do

          it "should return true" do
            @tag.should be_valid
          end

        end

        describe "and another tag in a different project has the same name" do

          before(:each) do
            Shrink::Tag.create!(:project => @other_project, :name => @tag.name)
          end

          it "should return true" do
            @tag.should be_valid
          end

        end

        describe "and another tag in the same project has the same name" do

          before(:each) do
            Shrink::Tag.create!(:project => @project, :name => @tag.name)
          end

          it "should return false" do
            @tag.should_not be_valid
          end

        end

      end

    end

    context "#find_or_new" do

      before(:each) do
        @tag = Shrink::Tag.create!(:project => @project, :name => "Some Name")
      end

      describe "when a tag with" do

        describe "the same project" do

          describe "and name already exists" do

            it "should return the existing tag" do
              Shrink::Tag.find_or_new(:project => @tag.project, :name => @tag.name).should eql(@tag)
            end

          end

          describe "and a different name already exists" do

            it "should create and return the created tag" do
              find_or_new_and_expect_new_tag(:project => @tag.project, :name => "Some Other Name")
            end

          end

        end

        describe "a different project and same name already exists" do

          it "should return a persisted tag with the same name" do
            find_or_new_and_expect_new_tag(:project => @other_project, :name => @tag.name)
          end

        end

      end

      def find_or_new_and_expect_new_tag(expected_attributes)
        new_tag = Shrink::Tag.find_or_new(expected_attributes)

        new_tag.should be_a_new_record
        expected_attributes.each do |attribute_name, attribute_value|
          new_tag.send(attribute_name).should eql(attribute_value)
        end
      end

    end

    context "#find_or_create!" do

      before(:each) do
        @tag = Shrink::Tag.create!(:project => @project, :name => "Some Name")
      end

      describe "when a tag with" do

        describe "the same project" do

          describe "and name already exists" do

            it "should return the existing tag" do
              Shrink::Tag.find_or_create!(:project => @tag.project, :name => @tag.name).should eql(@tag)
            end

          end

          describe "and a different name already exists" do

            it "should create and return the created tag" do
              find_or_create_and_expect_created_tag(:project => @tag.project, :name => "Some Other Name")
            end

          end

        end

        describe "a different project and same name already exists" do

          it "should return a persisted tag with the same name" do
            find_or_create_and_expect_created_tag(:project => @other_project, :name => @tag.name)
          end

        end

      end

      def find_or_create_and_expect_created_tag(expected_attributes)
        created_tag = Shrink::Tag.find_or_create!(expected_attributes)

        created_tag.should_not be_a_new_record
        expected_attributes.each do |attribute_name, attribute_value|
          created_tag.send(attribute_name).should eql(attribute_value)
        end
      end

    end

  end

end
