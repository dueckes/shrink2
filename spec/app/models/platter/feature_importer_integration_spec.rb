describe Platter::FeatureImporter do

  describe Platter::FeatureImporter::DirectoryImporter do

    describe "integrating with the file system and database" do

      before(:all) do
        @root_folder = Platter::Folder.root
      end

      after(:all) do
        #TODO Transactional specs doesn't appear to be configured
        Platter::Folder.destroy_all("parent_id is not null")
        Platter::Feature.destroy_all
      end

      describe "and configured for use with cucumber" do

        describe "when a directory contains one feature" do

          describe "and the feature is valid" do

            before(:all) do
              @directory_path = "#{SPEC_RESOURCES_DIR}/directory_with_one_feature"
              @imported_features = import_directory
            end

            it "should save the feature" do
              Platter::Feature.find_by_title("First").should_not be_nil
            end

            it "should return the feature" do
              @imported_features.should have(1).feature
              @imported_features[0].title.should eql("First")
            end

          end

        end

        describe "when a directory contains many features" do

          describe "and all the features are valid" do

            before(:all) do
              @directory_path = "#{SPEC_RESOURCES_DIR}/directory_with_many_valid_features"
              @imported_features = import_directory
              @expected_titles = %w(First Second Third)
            end

            it "should save the features" do
              @expected_titles.each do |expected_title|
                Platter::Feature.find_by_title(expected_title).should_not be_nil
              end
            end

            it "should return the features" do
              @imported_features.collect(&:title).sort.should eql(@expected_titles.sort)
            end

          end

          describe "and a feature is invalid" do

            before(:all) do
              puts "Platter::Feature.count: #{Platter::Feature.count}"
              @directory_path = "#{SPEC_RESOURCES_DIR}/directory_with_many_features_one_being_invalid"
              @imported_features = import_directory
              @feature_titles = %w(First Second Third)
            end

            it "should not save the features" do
              @feature_titles.each do |feature_title|
                Platter::Feature.find_by_title(feature_title).should be_nil
              end
            end

            it "should return all of the features" do
              @imported_features.collect(&:title).sort.should eql(@feature_titles.sort)
            end

          end

        end

        describe "when a directory contains sub-directories with features" do

          describe "and the features are valid" do

            before(:all) do
              @directory_path = "#{SPEC_RESOURCES_DIR}/directory_with_sub_directories_having_features"
              @imported_features = import_directory

              @expected_directories_and_feature_titles = {
                      "first_sub_directory" => %w(First Second Third),
                      "second_sub_directory" => %w(Fourth Fifth Sixth),
                      "third_sub_directory" => %w(Seventh Eighth Nineth),
                      "first_sub_sub_directory" => %w(Tenth Eleventh Twelf) }
            end

            it "should create folders for each sub-directory" do
              @expected_directories_and_feature_titles.keys.each do |folder_name|
                folder = Platter::Folder.find_by_name(folder_name)
                folder.should_not be_nil
                if folder_name =~ /sub_sub/
                  folder.parent.name.should eql(folder_name.gsub(/sub_sub/, "sub"))
                else
                  folder.parent.should eql(@root_folder)
                end
              end
            end

            it "should save the features in folder representations of their directories" do
              @expected_directories_and_feature_titles.each do |folder_name, feature_titles|
                folder = Platter::Folder.find_by_name(folder_name)
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
          Platter::FeatureImporter::DirectoryImporter.new(
                  :feature_adapter => Platter::Cucumber::FeatureAdapter,
                  :feature_file_manager => Platter::Cucumber::FeatureFileManager,
                  :directory_path => @directory_path,
                  :destination_folder => @destination_folder).import
        end

      end
    end
  end
end