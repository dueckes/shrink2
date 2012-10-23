module Shrink
  module Zip
    module ZipFile

      def self.included(object)
        object.extend(ClassMethods)
      end

      module ClassMethods

        def extract(zip_file, destination)
          FileUtils.rm_rf(destination)
          FileUtils.mkdir_p(destination)
          ::Zip::ZipFile.foreach(zip_file) do |entry|
            extract_path = "#{destination}/#{entry.name}"
            FileUtils.mkdir_p(File.dirname(extract_path))
            entry.extract(extract_path) { true }
          end
        end

      end
    end
  end
end
