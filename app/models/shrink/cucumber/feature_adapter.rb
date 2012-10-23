module Shrink
  module Cucumber

    class FeatureAdapter

      class << self

        def to_feature(file)
          Shrink::Cucumber::FeatureFileReader.read(file)
        end

        def to_file(feature, file_system, destination_directory)
          file_path = Shrink::Cucumber::FeatureFileManager.name_for(feature)
          file_path = File.join(destination_directory, file_path) if destination_directory
          file_system.open(file_path, "w") { |file| file << feature.to_cucumber_file_format }
          file_path
        end

      end

    end
  end
end
