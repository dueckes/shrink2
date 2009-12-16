describe Platter::Cucumber::FolderExporter do

  describe "integrating with the file system and database" do

    after(:all) do
      delete_export_files
    end

    context "#export" do

      describe "when given a folder" do

        before(:each) do
          @folder = Platter::Folder.new(:name => "Some Folder")
        end

        it "should return the path to the created zip file within the folder export directory" do
          file_path = export_folder

          file_path.should_not be_nil
          file_path.should match(/^#{Regexp.escape(Platter::Folder::EXPORT_DIRECTORY)}/)
        end

        it "should name the zip file having the fileized folder name with a 'zip' extension" do
          @folder.name.stub!(:fileize).and_return("some_fileized_folder_name")

          file_path = export_folder

          file_path.should match(/some_fileized_folder_name\.zip/)
        end

      end

      describe "when the folder is not the root folder" do

        before(:each) do
          @folder = Platter::Folder.create!(:name => "Some Folder", :parent => Platter::Folder.root)
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
              @descendant_folder_one_level_deep = Platter::Folder.create!(
                      :name => "Descendant One", :parent => @folder)
              @descendant_folder_one_level_deep_features = create_features_in(@descendant_folder_one_level_deep)
              @descendant_folder_two_levels_deep = Platter::Folder.create!(
                      :name => "Descendant Two", :parent => @descendant_folder_one_level_deep)
              @descendant_folder_two_levels_deep_features = create_features_in(@descendant_folder_two_levels_deep)
              @descendant_folder_three_levels_deep = Platter::Folder.create!(
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

      describe "when the folder is the root folder" do

        before(:each) do
          @folder = Platter::Folder.root
          @folder.children.clear
          @folder.features.clear
        end

        describe "and the folder contains a feature" do

          before(:each) do
            @feature = Platter::Feature.create!(:title => "Some Feature", :folder => @folder)
            @folder.features(true)
          end

          it "should create a zip file containing the features file without a directory" do
            entry_names = export_folder_to_entry_names
            entry_names.should eql([expected_feature_file_name(@feature)])
          end

        end

      end

      describe "when the folder contains no features" do

        before(:each) do
          @folder = Platter::Folder.new(:name => "Some Name)")
        end

        it "should create an empty zip file" do
          export_folder_to_entry_names.should be_empty
        end

      end

      def export_folder
        Platter::Cucumber::FolderExporter.export(@folder)
      end

      def export_folder_to_entry_names
        entry_names = []
        Zip::ZipFile.foreach(export_folder) { |entry| entry_names << entry.to_s }
        entry_names
      end

      def expected_feature_file_name(feature)
        Platter::Cucumber::FeatureFileNamer.name_for(feature)
      end

      def export_path (folder)
        folder.file_path
      end

      def create_features_in(folder)
        (1..3).collect { |i| Platter::Feature.create!(:title => "#{folder.name} Feature#{i}", :folder => folder) }
        folder.features(true)
      end

      def delete_export_files
        FileUtils.rm_rf(Dir.glob("#{Platter::Folder::EXPORT_DIRECTORY}/*"))
      end

    end

  end

end
