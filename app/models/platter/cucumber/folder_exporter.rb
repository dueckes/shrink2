module Platter
  module Cucumber

    class FolderExporter

      class << self

        def export(folder)
          create_zip(folder) { |zip_file| add_folder(zip_file, folder) }
        end

        private
        def create_zip(folder, &block)
          zip_filename = File.expand_path("#{Platter::Folder::EXPORT_DIRECTORY}/#{folder.name.fileize}.zip")
          FileUtils.rm_rf(zip_filename)
          Zip::ZipFile.open(zip_filename, Zip::ZipFile::CREATE) { |zip_file| block.call(zip_file) }
          zip_filename
        end

        def add_folder(zip_file, folder)
          zip_file.dir.mkdir(folder.file_path) unless folder.root?
          add_features(zip_file, folder.features)
          folder.children.each { |sub_folder| add_folder(zip_file, sub_folder) }
        end

        def add_features(zip_file, features)
          features.each do |feature|
            filename = Platter::Cucumber::FeatureFileNamer.name_for(feature)
            filename = "#{feature.folder.file_path}/#{filename}" unless feature.folder.root?
            zip_file.file.open(filename, "w") { |file| file << feature.to_cucumber_file_format }
          end
        end

      end

    end
  end
end
