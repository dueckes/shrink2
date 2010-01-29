describe Shrink::Feature do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    describe "when a feature has been created" do
      it_should_behave_like ClearDatabaseAfterEach

      before(:each) do
        @feature = create_feature!
      end

      context "#valid?" do

        describe "when a title is established" do

          describe "and the title is the same as another features title in the same folder" do

            before(:each) do
              create_feature!(:title => "Same Title", :folder => @feature.folder)
              @feature.title = "Same Title"
            end

            it "should return false" do
              @feature.should_not be_valid
            end

          end

          describe "and the title is the same as another features title in a different folder" do

            before(:each) do
              different_folder = create_folder!(:name => "Different Folder")
              create_feature!(:title => "Same Title", :folder => different_folder)
              @feature.title = "Same Title"
            end

            it "should return true" do
              @feature.should be_valid
            end

          end

        end

      end

      context "#project" do

        before(:each) do
          @project = @feature.project
        end

        it "should not be destroyed with the feature is destroyed" do
          @feature.destroy

          Shrink::Project.find_by_id(@project.id).should_not be_nil
        end

      end

      context "#folder" do

        before(:each) do
          @folder = @feature.folder
        end

        it "should not be destroyed with the feature is destroyed" do
          @feature.destroy

          Shrink::Folder.find_by_id(@folder.id).should_not be_nil
        end

      end

      context "#feature_tags" do

        before(:each) do
          @feature_tags = %w(a_name z_name m_name).collect do |tag_name|
            tag = Shrink::Tag.create!(:project => @feature.project, :name => tag_name)
            Shrink::FeatureTag.create!(:feature => @feature, :tag => tag)
          end
          @feature.feature_tags(true)
        end

        it "should all be destroyed when the feature is destroyed" do
          @feature.destroy

          @feature_tags.each { |feature_tag| Shrink::FeatureTag.find_by_id(feature_tag.id).should be_nil }
        end

      end

      context "#tags" do

        describe "when tags have been added" do

          before(:each) do
            @tags = %w(a_name z_name m_name).collect do |tag_name|
              tag = Shrink::Tag.create!(:project => @feature.project, :name => tag_name)
              @feature.tags << tag
              tag
            end
            @feature.tags(true)
          end

          it "should have the same amount of tags that have been added" do
            @feature.tags.should have(3).tags
          end

          it "should be ordered in descending order of tag name" do
            @feature.tags.collect(&:name).should eql(%w(a_name m_name z_name))
          end

          it "should not be destroyed when the feature is destroyed" do
            @feature.destroy

            @tags.each { |tag| Shrink::Tag.find_by_id(tag.id).should_not be_nil }
          end

        end

      end

      context "#description_lines" do

        describe "when description lines have been added" do

          before(:each) do
            @description_lines = (1..3).collect do |i|
              Shrink::FeatureDescriptionLine.create!(
                      :text => "Description Line Text #{i}", :position => 4 - i, :feature => @feature)
            end
            @feature.description_lines(true)
          end

          it "should have the same amount of description lines that have been added" do
            @feature.description_lines.should have(3).description_lines
          end

          it "should be ordered by position" do
            @feature.description_lines.each_with_index do |description_line, i|
              description_line.text.should eql("Description Line Text #{3 - i}")
            end
          end

          it "should all be destroyed when the feature is destroyed" do
            @feature.destroy

            @description_lines.each do |description_line|
              Shrink::FeatureDescriptionLine.find_by_id(description_line.id).should be_nil
            end
          end

        end

      end

      context "#scenarios" do

        describe "when scenarios have been added" do

          before(:each) do
            @scenarios = (1..3).collect do |i|
              Shrink::Scenario.create!(:title => "Scenario Title #{i}", :position => 4 - i, :feature => @feature)
            end
            @feature.scenarios(true)
          end

          it "should have the same amount of scenarios that have been added" do
            @feature.scenarios.should have(3).scenarios
          end

          it "should be ordered by position" do
            @feature.scenarios.each_with_index { |scenario, i| scenario.title.should eql("Scenario Title #{3 - i}") }
          end

          it "should all be destroyed when the feature is destroyed" do
            @feature.destroy

            @scenarios.each { |scenario| Shrink::Scenario.find_by_id(scenario.id).should be_nil }
          end

        end

      end

      context "#save" do

        describe "when an extraordinarily large number of constituents have been added" do

          before(:each) do
            @feature = Shrink::Feature.new(:title => "Some extraordinarily large feature",
                                           :folder => find_or_create_folder!)
            (1..30).each do |i|
              @feature.description_lines <<
                      Shrink::FeatureDescriptionLine.new(:text => "Some extraordinarily large description line #{i}")
              @feature.scenarios <<
                      (scenario = Shrink::Scenario.new(:title => "Some extraordinarily large scenario #{i}"))
              (1..10).each do |j|
                scenario.steps << Shrink::Step.new(:text => "Some extraordinarily large step #{j}")
              end
            end
          end

          it "should execute without error" do
            @feature.save.should be_true
          end

        end

      end

    end

  end

end
