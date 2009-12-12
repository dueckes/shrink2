module Platter
  describe Feature do

    it "should belong to a package" do
      package = Package.new(:name => "Some package")

      feature = Feature.new(:package => package)

      feature.package.should eql(package)
    end

    it "should have a title" do
      feature = Feature.new(:title => "Some Title")

      feature.title.should eql("Some Title")
    end

    it "should have tags" do
      feature = Feature.new

      tags = (1..3).collect do |i|
        tag = create_mock_tag(:name => "Tag#{i}")
        feature.tags << tag
        tag
      end

      feature.tags.should eql(tags)
    end

    it "should have feature lines" do
      feature = Feature.new

      lines = (1..3).collect do |i|
        line = create_mock_line(:text => "Line#{i}")
        feature.lines << line
        line
      end

      feature.lines.should eql(lines)
    end

    it "should have scenarios" do
      feature = Feature.new

      scenarios = (1..3).collect do |i|
        scenario = create_mock_scenario(:title => "Scenario#{i}")
        feature.scenarios << scenario
        scenario
      end

      feature.scenarios.should eql(scenarios)
    end

    it "should be a Platter::Cucumber::Adapter::AstFeatureAdapter" do
      Feature.include?(Platter::Cucumber::Adapter::AstFeatureAdapter).should be_true
    end

    it "should be a Platter::Cucumber::Formatter::FeatureFormatter" do
      Feature.include?(Platter::Cucumber::Formatter::FeatureFormatter).should be_true
    end

    context "#valid?" do

      before(:each) do
        @feature = Feature.new(:package => Package.new(:name => "Some package"), :title => "Some Title")
      end

      describe "when a package has been provided" do

        describe "and a title has been provided" do

          describe "whose length is less than 256 characters" do

            before(:each) do
              @feature.title = "a" * 255
            end

            it "should return true" do
              @feature.should be_valid
            end

          end

          describe "whose length is 256 characters" do

            before(:each) do
              @feature.title = "a" * 256
            end

            it "should return true" do
              @feature.should be_valid
            end

          end

          describe "whose length is greater than 256 characters" do

            before(:each) do
              @feature.title = "a" * 257
            end

            it "should return false" do
              @feature.should_not be_valid
            end

          end

          describe "that is empty" do

            before(:each) do
              @feature.title = ""
            end

            it "should return false" do
              @feature.should_not be_valid
            end

          end

        end

        describe "and a title has not been provided" do

          before(:each) do
            @feature.title = nil
          end

          it "should return false" do
            @feature.should_not be_valid
          end

        end

      end

      describe "when a package has not been provided" do

        before(:each) do
          @feature.package = nil
        end

        it "should return false" do
          @feature.should_not be_valid
        end

      end

      describe "when an invalid line has been added" do

        before(:each) do
          @feature.lines << FeatureLine.new(:text => "")
        end

        it "should return false" do
          @feature.should_not be_valid
        end

      end

      describe "when an invalid scenario has been added" do

        before(:each) do
          @feature.scenarios << Scenario.new(:title => "")
        end

        it "should return false" do
          @feature.should_not be_valid
        end

      end

    end

    context "#tag_line" do

      before(:each) do
        @feature = Feature.new
      end

      describe "when no tag is associated with the feature" do

        it "should return an empty string" do
          @feature.tag_line.should eql("")
        end

      end

      describe "when one tag is associated with the feature" do

        before(:each) do
          @feature.tags << Tag.new(:name => "Some Tag")
        end

        it "should return the name of the tag" do
          @feature.tag_line.should eql("Some Tag")
        end

      end

      describe "when many tags are associated with the feature" do

        before(:each) do
          (1..3).each { |i| @feature.tags << Tag.new(:name => "Tag#{i}") }
        end

        it "should return a string with a comma delimited list of tag names" do
          @feature.tag_line.should eql("Tag1, Tag2, Tag3")
        end

      end
      
    end

    context "#tag_line=" do

      before(:each) do
        @feature = Feature.new
        @feature.stub!(:update_summary!)
        @tag_name = "Some Tag"
        @tag = Tag.new(:name => @tag_name)
        Tag.stub!(:find_or_create!).and_return(@tag)
      end

      describe "when a tag is added" do

        it "should find or create the tag" do
          Tag.should_receive(:find_or_create!).with(:name => @tag_name)

          @feature.tag_line = @tag_name
        end

        it "should associate the tag with the feature" do
          @feature.tag_line = @tag_name

          @feature.tags.should include(@tag)
        end

      end

      describe "when a tag is removed" do

        before(:each) do
          @feature.tags << @tag
        end

        it "should not delete the tag" do
          @tag.should_not_receive(:destroy)

          @feature.tag_line = ""
        end

        it "should disassociate the tag from the feature" do
          @feature.tag_line = ""

          @feature.tags.should be_empty
        end

      end

      describe "when multiple tags are added and removed" do

        before(:each) do
          @tags = (1..6).collect do |i|
            tag = Tag.new(:name => "Tag#{i}")
            Tag.stub!(:find_or_create!).with(:name => tag.name).and_return(tag)
            tag
          end
          @tags_to_remove = @tags[0..2]
          @tags_to_add = @tags[3..5]

          @tags_to_remove.each { |tag| @feature.tags << tag }

          @feature.tag_line = @tags_to_add.collect(&:name).join(", ")
        end

        it "should associate those tags that have been added to the feature" do
          @tags_to_add.each { |associated_tag| @feature.tags.should include(associated_tag) }
        end

        it "should dissociate those tags that have been removed from the feature" do
          @tags_to_remove.each { |disassociated_tag| @feature.tags.should_not include(disassociated_tag) }
        end

      end

      it "should update the feature summary" do
        @feature.should_receive(:update_summary!)

        @feature.tag_line = ""
      end

    end

    context "#unused_tags" do

      before(:each) do
        @feature = Feature.new
        @all_tags = (1..3).collect { |i| Tag.new(:name => "Tag#{i}") }
      end

      it "should return unused tags ordered by name" do
        all_tags = %w(a b c).collect { |letter| Tag.new(:name => letter) }
        Tag.should_receive(:find).with(:all, :order => "name").and_return(all_tags)

        @feature.tags << all_tags[1]
        
        @feature.unused_tags.should eql([all_tags[0], all_tags[2]])
      end

      describe "when no tags exist" do

        before(:each) do
          Tag.stub!(:find).and_return([])
        end

        it "should be empty" do
          @feature.unused_tags.should be_empty
        end

      end

      describe "when tags exist" do

        before(:each) do
          Tag.stub!(:find).and_return(@all_tags)
        end

        describe "and the feature is associated with no tags" do

          it "should return all tags" do
            @feature.unused_tags.should eql(@all_tags)
          end

        end

        describe "and the feature is associated with a tag" do

          before(:each) do
            @feature.tags << @all_tags[0]
          end

          it "should return all tags excluding the tag associated with the feature" do
            @feature.unused_tags.should eql(@all_tags[1..2])
          end

        end

        describe "and the feature is associated with many tags" do

          before(:each) do
            @all_tags[0..1].each { |tag| @feature.tags << tag }
          end

          it "should return all tags excluding the tags associated with feature" do
            @feature.unused_tags.should eql([@all_tags[2]])
          end
        
        end

        describe "and the feature is associated with all tags" do

          before(:each) do
            @all_tags.each { |tag| @feature.tags << tag }
          end

          it "should be empty" do
            @feature.unused_tags.should be_empty
          end

        end

      end

    end

    context "#update_summary!" do

      before(:each) do
        @feature = Feature.new
      end

      it "should invoke update_attributes!" do
        @feature.should_receive(:update_attributes!)

        @feature.update_summary!
      end

      it "should update the summary to a value retrieved from summarizing the feature" do
        @feature.stub!(:summarize).and_return("Some Summary")
        @feature.stub!(:update_attributes!).with(:summary => "Some Summary")

        @feature.update_summary!
      end

    end

    context "#search_result_preview_lines" do
      #TODO
    end

    context "#summarize" do

      before(:each) do
        @feature = Feature.new(:title => "Some Feature Title")
      end

      describe "when the feature is fully populated" do

        before(:each) do
          @tags = (1..3).collect { |i| mock("Tag#{i}", :summarize => "tag_#{i}") }
          @feature.stub!(:tags).and_return(@tags)
          @lines = (1..3).collect { |i| mock("FeatureLine#{i}", :summarize => "feature line #{i}") }
          @feature.stub!(:lines).and_return(@lines)
          @scenarios = (1..3).collect { |i| mock("Scenario#{i}", :summarize => "scenario #{i}") }
          @feature.stub!(:scenarios).and_return(@scenarios)
          
          @summary_lines = @feature.summarize.split("\n")
        end

        describe "the feature title" do

          it "should be on the first line of text" do
            @summary_lines.first.should include("Some Feature Title")
          end

        end

        describe "the tag summaries" do

          it "should be space delimited on the second line of text" do
            @summary_lines.second.should eql("tag_1 tag_2 tag_3")
          end

        end


        describe "the line summaries" do

          it "should occupy a line each and by prefixed by spaces and displayed directly after the feature title" do
            @summary_lines[2..4].should eql(["  feature line 1", "  feature line 2", "  feature line 3"])
          end

        end

        describe "the scenario summaries" do

          it "should be divided from the feature lines by an empty line" do
            @summary_lines[5].should be_empty
          end

          it "should occupy a line each divided by an empty line" do
            @summary_lines[6..10].should eql(["scenario 1", "", "scenario 2", "", "scenario 3"])
          end

        end

      end

    end

    def create_mock_tag(stubs)
      StubModelFixture.create_model(Tag, stubs)
    end

    def create_mock_line(stubs)
      StubModelFixture.create_model(FeatureLine, stubs)
    end

    def create_mock_scenario(stubs)
      StubModelFixture.create_model(Scenario, stubs)
    end

  end
end