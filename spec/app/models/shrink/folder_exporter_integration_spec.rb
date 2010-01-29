describe Shrink::FolderExporter do

  describe "integrating with the file system and database" do

    describe "and configured for use with cucumber" do

      before(:all) do
        @folder_exporter = Shrink::FolderExporter.new(Shrink::Cucumber::FeatureAdapter)
        @feature_file_manager = Shrink::Cucumber::FeatureFileManager
        @zip_root_directory = "#{SPEC_TMP_DIR}/folder_exporter_integration_spec"
      end

      before(:each) do
        @project = Shrink::Project.create!(:name => "Folder Exporter Test Folder")
      end

      after(:each) do
        Shrink::Project.destroy_all
      end

      after(:all) do
        delete_export_files
      end

      context "#export" do

        describe "when given a folder" do

          before(:each) do
            @folder = Shrink::Folder.new(:name => "Some Folder")
          end

          it "should return the path to the created zip file in the provided zip root directory" do
            file_path = export_folder

            file_path.should_not be_nil
            file_path.should match(/^#{Regexp.escape(@zip_root_directory)}/)
          end

          it "should name the zip file using the folder name with a 'zip' extension" do
            file_path = export_folder

            file_path.should match(/Some Folder\.zip/)
          end

          describe "and the folder has been extracted to the same directory previously" do

            before(:each) do
              ::Zip::ZipFile.open("#{@zip_root_directory}/Some Folder.zip", ::Zip::ZipFile::CREATE) do |zip_file|
                zip_file.file.open("test.feature", "w") { |file| file << "Feature: Test Feature" }
              end
            end

            it "should delete the contents of the directory prior to creating the zip" do
              export_folder

              export_folder_to_entry_names.should_not include("test.feature")
            end

          end

        end

        describe "when the folder is not the root folder" do

          before(:each) do
            @folder = Shrink::Folder.create!(:name => "Some Folder", :parent => @project.root_folder)
          end

          describe "and the folder contains features" do

            before(:each) do
              @features = create_features_in(@folder)
            end

            describe "and no child folders" do

              it "should create a zip file containing the features in a directory relative to the root folder" do
                expected_entry_names = @features.collect do |feature|
                  "#{export_path(@folder)}/#{expected_feature_file_name(feature)}"
                end << "#{export_path(@folder)}/"

                entry_names = export_folder_to_entry_names

                entry_names.sort.should eql(expected_entry_names.sort)
              end

            end

            describe "and nested child folders containing features" do

              before(:each) do
                @descendant_folder_one_level_deep = Shrink::Folder.create!(
                        :name => "Descendant One", :parent => @folder)
                @descendant_folder_one_level_deep_features = create_features_in(@descendant_folder_one_level_deep)
                @descendant_folder_two_levels_deep = Shrink::Folder.create!(
                        :name => "Descendant Two", :parent => @descendant_folder_one_level_deep)
                @descendant_folder_two_levels_deep_features = create_features_in(@descendant_folder_two_levels_deep)
                @descendant_folder_three_levels_deep = Shrink::Folder.create!(
                        :name => "Descendant Three", :parent => @descendant_folder_two_levels_deep)
                @descendant_folder_three_levels_deep_features = create_features_in(@descendant_folder_three_levels_deep)

                @folders = [@folder, @descendant_folder_one_level_deep,
                            @descendant_folder_two_levels_deep, @descendant_folder_three_levels_deep]
                @features = [@features, @descendant_folder_one_level_deep_features,
                             @descendant_folder_two_levels_deep_features,
                             @descendant_folder_three_levels_deep_features].flatten
              end

              it "should create a zip file containing the features in directories relative to the root folder" do
                expected_entry_names = @features.collect do |feature|
                  "#{export_path(feature.folder)}/#{expected_feature_file_name(feature)}"
                end + @folders.collect { |folder| "#{export_path(folder)}/" }

                entry_names = export_folder_to_entry_names

                entry_names.sort.should eql(expected_entry_names.sort)
              end

            end

          end

        end

        describe "when the folder is a project root folder" do

          before(:each) do
            @folder = @project.root_folder
          end

          describe "and the folder contains a feature" do

            before(:each) do
              @feature = Shrink::Feature.create!(:title => "Some Feature", :folder => @folder)
              @folder.features(true)
            end

            it "should create a zip file containing the feature file without a directory" do
              entry_names = export_folder_to_entry_names
              entry_names.should eql([expected_feature_file_name(@feature)])
            end

          end

        end

        describe "when the folder contains no features" do

          before(:each) do
            @folder = Shrink::Folder.new(:name => "Some Name)")
          end

          it "should create an empty zip file" do
            export_folder_to_entry_names.should be_empty
          end

        end

        def export_folder
          @folder_exporter.export(:folder => @folder, :zip_root_directory => @zip_root_directory)
        end

        def export_folder_to_entry_names
          entry_names = []
          ::Zip::ZipFile.foreach(export_folder) { |entry| entry_names << entry.name }
          entry_names
        end

        def expected_feature_file_name(feature)
          @feature_file_manager.name_for(feature)
        end

        def export_path(folder)
          folder.directory_path
        end

        def create_features_in(folder)
          (1..3).collect { |i| Shrink::Feature.create!(:title => "#{folder.name} Feature#{i}", :folder => folder) }
          folder.features(true)
        end

        def delete_export_files
          FileUtils.rm_rf(Dir.glob("#{@zip_root_directory}/*"))
        end

      end

    end

  end

end
