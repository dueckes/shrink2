module Platter
  module Cucumber

    class FeatureImporter

      class << self

        def import_file(file_path)
          Platter::Cucumber::FeatureFileReader.read_files(file_path).first
        end

        def import_directory(directory_path)
          feature_per_file(directory_path).collect do |file, feature|
            relative_directory = File.dirname(file).delete(directory_path)
            package = Platter::Package.find_or_create!(relative_directory)
            package.features << feature
            feature
          end
        end

        private
        def feature_per_file(directory_path)
          files = Dir.glob("#{directory_path}/**/*.feature")
          features = Platter::Cucumber::FeatureFileReader.read_files(files)
          files.hasherize { |file, i| [file, features[i]] }
        end

      end

    end

  end
end
