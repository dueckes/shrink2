describe "A taggable model integrating with the database", :shared => true do

  context "##{described_class.short_name}_tags" do

    before(:all) do
      @model_name = described_class.short_name
      @tag_class = eval("#{described_class.name}Tag")
    end

    before(:each) do
      @model_tags = %w(a_name z_name m_name).collect do |tag_name|
        tag = create_tag!(:project => @model.feature.project, :name => tag_name)
        @tag_class.create!(@model_name => @model, :tag => tag)
      end
      @model.send("#{@model_name}_tags", true)
    end

    it "should all be destroyed when the #{described_class.short_name} is destroyed" do
      @model.destroy

      @model_tags.each { |model_tag| @tag_class.find_by_id(model_tag.id).should be_nil }
    end

  end

  context "#tags" do

    describe "when tags have been added" do

      before(:each) do
        @tags = %w(a_name z_name m_name).collect do |tag_name|
          tag = create_tag!(:project => @model.feature.project, :name => tag_name)
          @model.tags << tag
          tag
        end
        @model.tags(true)
      end

      it "should have the same amount of tags that have been added" do
        @model.tags.should have(3).tags
      end

      it "should be ordered in descending order of tag name" do
        @model.tags.collect(&:name).should eql(%w(a_name m_name z_name))
      end

      it "should not be destroyed when the #{described_class.short_name} is destroyed" do
        @model.destroy

        @tags.each { |tag| Shrink::Tag.find_by_id(tag.id).should_not be_nil }
      end

    end

  end

end
