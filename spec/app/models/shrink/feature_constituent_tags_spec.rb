describe Shrink::FeatureConstituentTags do

  class TestableFeatureConstituentTags < Array
    attr_reader :proxy_owner

    include Shrink::FeatureConstituentTags

    def initialize(proxy_owner=nil)
      @proxy_owner = proxy_owner
    end

  end

  context "#line" do

    before(:each) do
      @feature_constituent_tags = TestableFeatureConstituentTags.new
    end

    describe "when no tag has been added" do

      it "should return an empty string" do
        @feature_constituent_tags.line.should eql("")
      end

    end

    describe "when one tag has been added" do

      before(:each) do
        @feature_constituent_tags << Shrink::Tag.new(:name => "Some Tag")
      end

      it "should return the name of the tag" do
        @feature_constituent_tags.line.should eql("Some Tag")
      end

    end

    describe "when many tags have been added" do

      before(:each) do
        (1..3).each { |i| @feature_constituent_tags << Shrink::Tag.new(:name => "Tag#{i}") }
      end

      it "should return a string with a comma delimited list of tag names" do
        @feature_constituent_tags.line.should eql("Tag1, Tag2, Tag3")
      end

    end

  end

  context "#line=" do

    before(:each) do
      @project = Shrink::Project.new(:name => "Some Project")
      @feature = Shrink::Feature.new(:title => "Some Feature", :folder => Shrink::Folder.new(:project => @project))
      @feature.stub!(:update_summary!)
      @feature_constituent_tags = create_feature_constituent_tags(@feature)

      @tag_name = "Some Tag"
      @tag = Shrink::Tag.new(:name => @tag_name)
      Shrink::Tag.stub!(:find_or_create!).and_return(@tag)
    end

    describe "when a tag is added" do

      it "should find or create the tag within the project of the folder of the constituents feature" do
        Shrink::Tag.should_receive(:find_or_create!).with(:name => @tag_name, :project => @project)

        @feature_constituent_tags.line = @tag_name
      end

      it "should add the tag to the feature constituent tags" do
        @feature_constituent_tags.line = @tag_name

        @feature_constituent_tags.should include(@tag)
      end

    end

    describe "when a tag is removed" do

      before(:each) do
        @feature_constituent_tags << @tag
      end

      it "should not delete the tag" do
        @tag.should_not_receive(:destroy)

        @feature_constituent_tags.line = ""
      end

      it "should remove the tag from the feature constituent tags" do
        @feature_constituent_tags.line = ""

        @feature_constituent_tags.should be_empty
      end

    end

    describe "when multiple tags are added and removed" do

      before(:each) do
        @tags = create_tags(:number => 6, :project => @project) do |tag|
          Shrink::Tag.stub!(:find_or_create!).with(:name => tag.name, :project => @project).and_return(tag)
        end

        @feature_constituent_tags_to_remove = @tags[0..2]
        @feature_constituent_tags_to_remove.each { |tag| @feature_constituent_tags << tag }

        @feature_constituent_tags_to_add = @tags[3..5]
        @feature_constituent_tags.line = @feature_constituent_tags_to_add.collect(&:name).join(", ")
      end

      it "should add those tags that have been added to the line" do
        @feature_constituent_tags_to_add.each do |associated_tag|
          @feature_constituent_tags.should include(associated_tag)
        end
      end

      it "should remove those tags that have been removed from the line" do
        @feature_constituent_tags_to_remove.each do |disassociated_tag|
          @feature_constituent_tags.should_not include(disassociated_tag)
        end
      end

    end

    it "should update the feature constituents features summary" do
      @feature.should_receive(:update_summary!)

      @feature_constituent_tags.line = ""
    end

  end

  context "#unused" do

    before(:each) do
      project = Shrink::Project.new(:name => "Some Project")
      @project_tags = mock("ProjectTags")
      project.stub!(:tags).and_return(@project_tags)
      @feature = Shrink::Feature.new(:title => "Some Feature", :folder => Shrink::Folder.new(:project => project))
      @feature_constituent_tags = create_feature_constituent_tags(@feature)
      @all_tags = create_tags(:number => 3)
    end

    it "should return unused tags in the project of the folder of the constituents feature ordered by name" do
      @project_tags.should_receive(:find).with(:order => "name").and_return(@all_tags)

      @feature_constituent_tags << @all_tags[1]

      @feature_constituent_tags.unused.should eql([@all_tags[0], @all_tags[2]])
    end

    describe "when no tags exist" do

      before(:each) do
        @project_tags.stub!(:find).and_return([])
      end

      it "should be empty" do
        @feature_constituent_tags.unused.should be_empty
      end

    end

    describe "when tags exist" do

      before(:each) do
        @project_tags.stub!(:find).and_return(@all_tags)
      end

      describe "and the feature constituent is associated with no tags" do

        it "should return all tags" do
          @feature_constituent_tags.unused.should eql(@all_tags)
        end

      end

      describe "and the feature constituent is associated with a tag" do

        before(:each) do
          @feature_constituent_tags << @all_tags[0]
        end

        it "should return all tags excluding the tag associated with the feature constituent" do
          @feature_constituent_tags.unused.should eql(@all_tags[1..2])
        end

      end

      describe "and the feature constituent is associated with many tags" do

        before(:each) do
          @all_tags[0..1].each { |tag| @feature_constituent_tags << tag }
        end

        it "should return all tags excluding the tags associated with feature constituent" do
          @feature_constituent_tags.unused.should eql([@all_tags[2]])
        end

      end

      describe "and the feature constituent is associated with all tags" do

        before(:each) do
          @all_tags.each { |tag| @feature_constituent_tags << tag }
        end

        it "should be empty" do
          @feature_constituent_tags.unused.should be_empty
        end

      end

    end

  end

  context "#project=" do

    before(:each) do
      @project = Shrink::Project.new(:name => "Some Project")

      @feature = Shrink::Feature.new(:title => "Some Feature")
      @feature_constituent_tags = create_feature_constituent_tags(@feature)
    end

    describe "when the feature constituent is associated with many tags" do

      describe "and the tags are not associated with a project" do

        before(:each) do
          @tags = create_tags { |tag| @feature_constituent_tags << tag }
        end

        it "should associate the tags with the provided project by finding or instanciating a tag in the project with the same name" do
          found_or_new_tags = @tags.collect do |tag|
            found_or_new_tag = Shrink::Tag.new(:name => "Found Or New #{tag.name}")
            Shrink::Tag.should_receive(:find_or_new).with(:name => tag.name, :project => @project).and_return(found_or_new_tag)
            found_or_new_tag
          end

          @feature_constituent_tags.project = @project

          @feature_constituent_tags.should eql(found_or_new_tags)
        end

      end

      describe "and the tags are associated with a project" do
        
        before(:each) do
          @tags = create_tags(:project => @project) { |tag| @feature_constituent_tags << tag }
        end

        it "should leave the tags associated the original project" do
          @feature_constituent_tags.project = Shrink::Project.new(:name => "Some Other Project")

          @tags.each { |tag| tag.project.should eql(@project) }
        end

      end

    end

  end

  def create_feature_constituent_tags(feature)
    TestableFeatureConstituentTags.new(mock("ProxyOwner", :feature => feature))
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
