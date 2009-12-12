module Platter
  module Cucumber

    class FeatureExporter

      def self.export(feature, directory)
        file = Pathname.new(directory + FeatureFileNamer.name_for(feature))
        File.open(file, 'w') { |file_contents| file_contents << feature.to_cucumber_file_format }
      end

    end

  end
end
