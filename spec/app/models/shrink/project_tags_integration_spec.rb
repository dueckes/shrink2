describe Shrink::ProjectTags do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    before(:all) do
      @project = create_project!
      @project_tags = @project.tags
    end

    context "#find" do

      describe "when multiple projects contain multiple tags" do

        before(:all) do
          other_project = create_project!(:name => "Other Project")
          @tags_within_project = (1..3).collect do |i|
            create_tag!(:project => other_project, :name => "Tag #{i}")
            create_tag!(:project => @project, :name => "Tag #{i}")
          end
        end

        describe "and the conditions match multiple tags in multiple projects" do

          before(:all) do
            find_tags_ordered_by_name(:conditions => ["name like ?", "Tag %"])
          end

          it "should return the only the matching tags within the project" do
            @tags.should eql(@tags_within_project)
          end

        end

        describe "and the conditions match no tags within the project" do

          before(:all) do
            find_tags_ordered_by_name(:conditions => ["name = ?", "Does not match"])
          end

          it "should return an empty array" do
            @tags.should be_empty
          end

        end

      end

      describe "when a project contains no tags" do

        it "should return an empty array" do
          @project_tags.find(:all).should be_empty
        end

      end

      def find_tags_ordered_by_name(options)
        @tags = @project_tags.find(:all, { :order => "name asc" }.merge(options))
      end

    end

    context "#count" do

      describe "when the project contains multiple tags" do

        before(:all) do
          (1..3).each { |i| create_tag!(:project => @project, :name => "Tag #{i}") }
        end

        it "should return the number of tags within the project" do
          @project_tags.count.should eql(3)
        end

      end

      describe "when the project contains no tags" do

        it "should return 0" do
          @project_tags.count.should eql(0)
        end

      end

    end

  end

end
