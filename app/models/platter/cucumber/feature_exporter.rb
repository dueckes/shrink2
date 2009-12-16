module Platter
  module Cucumber

    class FeatureExporter

      def self.export(feature)
        export_to_directory(feature, Platter::Feature::EXPORT_DIRECTORY)
      end

      def self.export_to_directory(feature, directory)
        file_path = "#{directory}/#{FeatureFileNamer.name_for(feature)}"
        File.open(file_path, "w") { |file_contents| file_contents << feature.to_cucumber_file_format }
        file_path
      end

    end

  end
end
