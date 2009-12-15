module Platter
  module Cucumber

    class FeatureFileNamer

      def self.name_for(feature)
        "#{feature.base_filename}.feature"
      end

    end

  end
end
