module Platter

  class FolderImporter

    def initialize(feature_importer)
      @feature_importer = feature_importer
    end

    def import(options)
      ZipImporter.new(options.merge(:feature_importer => @feature_importer)).import
    end

    class ZipImporter

      def initialize(options)
        @feature_importer = options[:feature_importer]
        @zip_file_path = options[:zip_file_path]
        @extract_directory = calculate_extract_directory(options)
        @destination_folder = options[:destination_folder]
      end

      def import
        while_zip_is_extracted do
          @feature_importer.import(:directory_path => @extract_directory, :destination_folder => @destination_folder)
        end
      end

      private
      def calculate_extract_directory(options)
        File.join(options[:extract_root_directory], File.basename(options[:zip_file_path]).gsub(/\..*$/, ""))
      end

      def while_zip_is_extracted (&block)
        ::Zip::ZipFile.extract(@zip_file_path, @extract_directory)
        result = block.call
        FileUtils.rm_rf(@extract_directory)
        result
      end

    end

  end

end
