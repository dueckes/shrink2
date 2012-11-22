describe Shrink::FeatureImporter do

  describe Shrink::FeatureImporter::DirectoryImporter do

    describe "integrating with the file system and database" do
      include_context "database integration"

      describe "and configured for use with cucumber" do

        describe "when importing a file" do

          describe "containing a feature and a scenario within it contain tags" do
            include_context "clear database after all"

            before(:all) do
              @project = create_project!
              @file_path = "#{SPEC_RESOURCES_DIR}/tagged_feature_and_scenario.feature"
              @imported_feature = import_directory
            end

            it "should return a feature containing tags" do
              @imported_feature.tags.collect(&:name).should eql(%w(feature_tag_one feature_tag_two feature_tag_three))
            end

            it "should return a feature containing a scenario with tags" do
              scenario = @imported_feature.scenarios.first

              scenario.tags.collect(&:name).should eql(%w(scenario_tag_one scenario_tag_two scenario_tag_three))
            end

            def import_directory
              Shrink::FeatureImporter::FileImporter.new(
                      :feature_adapter => Shrink::Cucumber::FeatureAdapter,
                      :file_path => @file_path).import
            end

          end

        end

        describe "when importing a directory" do

          describe "containing one feature" do

            describe "and the feature is valid" do
              include_context "clear database after all"

              before(:all) do
                @project = create_project!
                @directory_path = "#{SPEC_RESOURCES_DIR}/directory_with_one_feature"
                @imported_features = import_directory
              end

              it "should save the feature" do
                Shrink::Feature.find_by_title("First").should_not be_nil
              end

              it "should return the feature" do
                @imported_features.should have(1).feature
                @imported_features[0].title.should eql("First")
              end

            end

          end

          describe "containing many features" do

            describe "and all the features are valid" do
              include_context "clear database after all"

              before(:all) do
                @project = create_project!
                @directory_path = "#{SPEC_RESOURCES_DIR}/directory_with_many_valid_features"
                @imported_features = import_directory
                @expected_titles = %w(First Second Third).collect { |prefix| "#{prefix} Feature Title" }
              end

              it "should save the features" do
                @expected_titles.each do |expected_title|
                  Shrink::Feature.find_by_title(expected_title).should_not be_nil
                end
              end

              it "should return the features" do
                @imported_features.collect(&:title).sort.should eql(@expected_titles.sort)
              end

            end

            describe "and a feature is invalid" do
              include_context "clear database after all"

              before(:all) do
                @project = create_project!
                @directory_path = "#{SPEC_RESOURCES_DIR}/directory_with_many_features_one_being_invalid"
                @imported_features = import_directory
                @feature_titles = %w(First Second Third)
              end

              it "should not save the features" do
                @feature_titles.each do |feature_title|
                  Shrink::Feature.find_by_title(feature_title).should be_nil
                end
              end

              it "should return all of the features" do
                @imported_features.collect(&:title).sort.should eql(@feature_titles.sort)
              end

            end

          end

          describe "containing sub-directories with features" do

            describe "and the features are valid" do
              include_context "clear database after all"

              before(:all) do
                @project = create_project!
                @directory_path = "#{SPEC_RESOURCES_DIR}/directory_with_sub_directories_having_features"
                @imported_features = import_directory

                @expected_directories_and_feature_titles = {
                        "first_sub_directory" => %w(First Second Third),
                        "second_sub_directory" => %w(Fourth Fifth Sixth),
                        "third_sub_directory" => %w(Seventh Eighth Ninth),
                        "first_sub_sub_directory" => %w(Tenth Eleventh Twelfth) }
              end

              it "should create folders for each sub-directory" do
                @expected_directories_and_feature_titles.keys.each do |folder_name|
                  folder = Shrink::Folder.find_by_name(folder_name)
                  folder.should_not be_nil
                  if folder_name =~ /sub_sub/
                    folder.parent.name.should eql(folder_name.gsub(/sub_sub/, "sub"))
                  else
                    folder.parent.should eql(@project.root_folder)
                  end
                end
              end

              it "should save the features in folder representations of their directories" do
                @expected_directories_and_feature_titles.each do |folder_name, feature_titles|
                  folder = Shrink::Folder.find_by_name(folder_name)
                  folder.features.collect(&:title).should include(*feature_titles)
                end
              end

              it "should return the features" do
                @imported_features.collect(&:title).sort.should eql(
                        @expected_directories_and_feature_titles.values.flatten.sort)
              end

            end

          end

          def import_directory
            Shrink::FeatureImporter::DirectoryImporter.new(
                    :feature_adapter => Shrink::Cucumber::FeatureAdapter,
                    :feature_file_manager => Shrink::Cucumber::FeatureFileManager,
                    :file_path => @file_path,
                    :directory_path => @directory_path,
                    :destination_folder => @project.root_folder).import
          end

        end

      end
    end
  end
end
