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

    it "should be a Platter::Cucumber::Ast::FeatureConverter" do
      Platter::Feature.include?(Platter::Cucumber::Ast::FeatureConverter).should be_true
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

            it "should return false" do
              @feature.should_not be_valid
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
          @feature.lines << Platter::FeatureLine.new(:text => "")
        end

        it "should return false" do
          @feature.should_not be_valid
        end

      end

      describe "when an invalid scenario has been added" do

        before(:each) do
          @feature.scenarios << Platter::Scenario.new(:title => "")
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

    context "#add_and_remove_tags" do

      #TODO Complete

    end

    context "#as_text" do

      it "should include the feature title" do
        title = "this is a feature title"
        Feature.new(:title => title).as_text.should include "Feature: #{title}"
      end

      it "should indent & include feature lines" do
        feature = Feature.new
        feature.lines << StubModelFixture.create_model(FeatureLine, :as_text => "first feature line")
        feature.lines << StubModelFixture.create_model(FeatureLine, :as_text => "second feature line")
        text = feature.as_text
        text.should include "  first feature line"
        text.should include "  second feature line"
      end

      it "should include scenarios" do
        feature = Feature.new
        feature.scenarios << StubModelFixture.create_model(Scenario, :as_text => "first scenario")
        feature.scenarios << StubModelFixture.create_model(Scenario, :as_text => "second scenario")
        text = feature.as_text
        text.should include "first scenario"
        text.should include "second scenario"
      end

    end

    context "#export_name"  do

      it "should use the title" do
        title = "some_title"
        Feature.new(:title => title).export_name.should eql title
      end

      it "should replace spaces with underscores" do
        Feature.new(:title => "title with spaces").export_name.should eql "title_with_spaces"
      end

      it "should downcase the title" do
        Feature.new(:title => "Title WITH MIXED cAse").export_name.should eql "title_with_mixed_case"
      end

      it "should drop all non alpha numeric characters" do
        Feature.new(:title => 'T1tle !@#$%with n0n alph4 numeric +)(*&^characters and numb3rs').export_name.should eql "t1tle_with_n0n_alph4_numeric_characters_and_numb3rs"
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