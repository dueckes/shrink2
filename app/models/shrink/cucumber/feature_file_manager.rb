module Shrink
  module Cucumber

    class FeatureFileManager
      EXTENSION = ".feature".freeze

      def self.name_for(feature)
        "#{feature.base_filename}#{EXTENSION}"
      end

      def self.files_in(directory_path)
        Dir.glob("#{directory_path}/**/*#{EXTENSION}")
      end

    end

  end
end
