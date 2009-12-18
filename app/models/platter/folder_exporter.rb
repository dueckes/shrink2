module Platter

  class FolderExporter

    def initialize(feature_adapter)
      @feature_adapter = feature_adapter
    end

    def export(options)
      ZipExporter.new(options.merge(:feature_adapter => @feature_adapter)).export
    end

    class ZipExporter

      def initialize(options)
        @feature_adapter = options[:feature_adapter]
        @folder = options[:folder]
        @zip_root_directory = options[:zip_root_directory]
      end

      def export
        create_zip { |zip_file| add_folder(zip_file, @folder) }
      end

      private
      def create_zip(&block)
        FileUtils.mkdir_p(@zip_root_directory)
        zip_file_path = File.expand_path(File.join(@zip_root_directory, "#{@folder.name}.zip"))
        FileUtils.rm_rf(zip_file_path)
        ::Zip::ZipFile.open(zip_file_path, ::Zip::ZipFile::CREATE) { |zip_file| block.call(zip_file) }
        zip_file_path
      end

      def add_folder(zip_file, folder)
        zip_file.dir.mkdir(folder.directory_path) unless folder.root?
        add_features(zip_file, folder.features)
        folder.children.each { |sub_folder| add_folder(zip_file, sub_folder) }
      end

      def add_features(zip_file, features)
        features.each do |feature|
          destination_directory = feature.folder.root? ? nil : feature.folder.directory_path
          @feature_adapter.to_file(feature, zip_file.file, destination_directory)
        end
      end

    end

  end
  
end
