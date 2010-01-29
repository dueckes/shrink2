module Shrink

  class FeatureImporter

    def initialize(feature_adapter, feature_file_manager)
      @feature_adapter = feature_adapter
      @feature_file_manager = feature_file_manager
    end

    def import(options)
      importer_class = options[:file_path] ?  FileImporter : DirectoryImporter
      combined_options = options.merge(:feature_adapter => @feature_adapter,
                                       :feature_file_manager => @feature_file_manager)
      importer_class.new(combined_options).import
    end

    class FileImporter

      def initialize(options)
        @feature_adapter = options[:feature_adapter]
        @file_path = options[:file_path]
      end

      def import
        @feature_adapter.to_feature(@file_path)
      end

    end

    class DirectoryImporter

      def initialize(options)
        @feature_adapter = options[:feature_adapter]
        @feature_file_manager = options[:feature_file_manager]
        @directory_path = options[:directory_path]
        @destination_folder = options[:destination_folder]
      end

      def import
        features = []
        ::ActiveRecord::Base.transaction do
          features = features_in_directory
          features.each(&:save)
          raise ::ActiveRecord::Rollback if features.detect { |feature| !feature.valid? }
        end
        features
      end

      private
      def features_in_directory
        @feature_file_manager.files_in(@directory_path).collect do |file_path|
          feature = @feature_adapter.to_feature(file_path)
          feature.folder = Shrink::Folder.find_or_create!(@destination_folder.project, feature_folder_path(file_path))
          feature
        end
      end

      def feature_folder_path(file_path)
        "#{@destination_folder.directory_path}/#{File.dirname(file_path).gsub(/^#{Regexp.escape(@directory_path)}/, "")}"
      end

    end

  end

end
