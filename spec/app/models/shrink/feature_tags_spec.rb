describe Shrink::FeatureTags do

  class TestableFeatureTags < Array
    attr_reader :proxy_owner

    include Shrink::FeatureTags

    def initialize(proxy_owner=nil)
      @proxy_owner = proxy_owner
    end

  end

  context "#line" do

    before(:each) do
      @feature_tags = TestableFeatureTags.new
    end

    describe "when no tag is associated with the feature" do

      it "should return an empty string" do
        @feature_tags.line.should eql("")
      end

    end

    describe "when one tag is associated with the feature" do

      before(:each) do
        @feature_tags << Shrink::Tag.new(:name => "Some Tag")
      end

      it "should return the name of the tag" do
        @feature_tags.line.should eql("Some Tag")
      end

    end

    describe "when many tags are associated with the feature" do

      before(:each) do
        (1..3).each { |i| @feature_tags << Shrink::Tag.new(:name => "Tag#{i}") }
      end

      it "should return a string with a comma delimited list of tag names" do
        @feature_tags.line.should eql("Tag1, Tag2, Tag3")
      end

    end

  end

  context "#line=" do

    before(:each) do
      @project = Shrink::Project.new(:name => "Some Project")
      @feature = Shrink::Feature.new(:title => "Some Feature", :folder => Shrink::Folder.new(:project => @project))
      @feature.stub!(:update_summary!)
      @feature_tags = TestableFeatureTags.new(@feature)

      @tag_name = "Some Tag"
      @tag = Shrink::Tag.new(:name => @tag_name)
      Shrink::Tag.stub!(:find_or_create!).and_return(@tag)
    end

    describe "when a tag is added" do

      it "should find or create the tag within the project of the features folder" do
        Shrink::Tag.should_receive(:find_or_create!).with(:name => @tag_name, :project => @project)

        @feature_tags.line = @tag_name
      end

      it "should associate the tag with the feature" do
        @feature_tags.line = @tag_name

        @feature_tags.should include(@tag)
      end

    end

    describe "when a tag is removed" do

      before(:each) do
        @feature_tags << @tag
      end

      it "should not delete the tag" do
        @tag.should_not_receive(:destroy)

        @feature_tags.line = ""
      end

      it "should disassociate the tag from the feature" do
        @feature_tags.line = ""

        @feature_tags.should be_empty
      end

    end

    describe "when multiple tags are added and removed" do

      before(:each) do
        @tags = create_tags(:number => 6, :project => @project) do |tag|
          Shrink::Tag.stub!(:find_or_create!).with(:name => tag.name, :project => @project).and_return(tag)
        end

        @tags_to_remove = @tags[0..2]
        @tags_to_remove.each { |tag| @feature_tags << tag }

        @tags_to_add = @tags[3..5]
        @feature_tags.line = @tags_to_add.collect(&:name).join(", ")
      end

      it "should associate those tags that have been added to the feature" do
        @tags_to_add.each { |associated_tag| @feature_tags.should include(associated_tag) }
      end

      it "should dissociate those tags that have been removed from the feature" do
        @tags_to_remove.each { |disassociated_tag| @feature_tags.should_not include(disassociated_tag) }
      end

    end

    it "should update the feature summary" do
      @feature.should_receive(:update_summary!)

      @feature_tags.line = ""
    end

  end

  context "#unused" do

    before(:each) do
      project = Shrink::Project.new(:name => "Some Project")
      @project_tags = mock("ProjectTags")
      project.stub!(:tags).and_return(@project_tags)
      @feature = Shrink::Feature.new(:title => "Some Feature", :folder => Shrink::Folder.new(:project => project))
      @feature_tags = TestableFeatureTags.new(@feature)
      @all_tags = create_tags(:number => 3)
    end

    it "should return unused tags in the project of the features folder ordered by name" do
      @project_tags.should_receive(:find).with(:order => "name").and_return(@all_tags)

      @feature_tags << @all_tags[1]

      @feature_tags.unused.should eql([@all_tags[0], @all_tags[2]])
    end

    describe "when no tags exist" do

      before(:each) do
        @project_tags.stub!(:find).and_return([])
      end

      it "should be empty" do
        @feature_tags.unused.should be_empty
      end

    end

    describe "when tags exist" do

      before(:each) do
        @project_tags.stub!(:find).and_return(@all_tags)
      end

      describe "and the feature is associated with no tags" do

        it "should return all tags" do
          @feature_tags.unused.should eql(@all_tags)
        end

      end

      describe "and the feature is associated with a tag" do

        before(:each) do
          @feature_tags << @all_tags[0]
        end

        it "should return all tags excluding the tag associated with the feature" do
          @feature_tags.unused.should eql(@all_tags[1..2])
        end

      end

      describe "and the feature is associated with many tags" do

        before(:each) do
          @all_tags[0..1].each { |tag| @feature_tags << tag }
        end

        it "should return all tags excluding the tags associated with feature" do
          @feature_tags.unused.should eql([@all_tags[2]])
        end

      end

      describe "and the feature is associated with all tags" do

        before(:each) do
          @all_tags.each { |tag| @feature_tags << tag }
        end

        it "should be empty" do
          @feature_tags.unused.should be_empty
        end

      end

    end

  end

  context "#project=" do

    before(:each) do
      @project = Shrink::Project.new(:name => "Some Project")

      @feature = Shrink::Feature.new(:title => "Some Feature")
      @feature_tags = TestableFeatureTags.new(@feature)
    end

    describe "when a feature is associated with many tags" do

      describe "and the tags are not associated with a project" do

        before(:each) do
          @tags = create_tags(:number => 3) { |tag| @feature_tags << tag }
        end

        it "should associate the tags with the project by finding or instanciating a tag in the project with the same name" do
          found_or_new_tags = @tags.collect do |tag|
            found_or_new_tag = Shrink::Tag.new(:name => "Found Or New #{tag.name}")
            Shrink::Tag.should_receive(:find_or_new).with(:name => tag.name, :project => @project).and_return(found_or_new_tag)
            found_or_new_tag
          end

          @feature_tags.project = @project

          @feature_tags.should eql(found_or_new_tags)
        end

      end

      describe "and the tags are associated with a project" do
        
        before(:each) do
          @tags = create_tags(:number => 3, :project => @project) { |tag| @feature_tags << tag }
        end

        it "should leave the tags associated the original project" do
          @feature_tags.project = Shrink::Project.new(:name => "Some Other Project")

          @feature_tags.each { |tag| tag.project.should eql(@project) }
        end

      end

    end

  end

  def create_tags(options={}, &tag_block)
    default_options = { :number => 3, :project => nil }
    combined_options = default_options.merge(options)
    (1..combined_options.delete(:number)).collect do |i|
      tag = Shrink::Tag.new({ :name => "Tag #{i}" }.merge(combined_options))
      tag_block.call(tag) if tag_block
      tag
    end
  end

end
