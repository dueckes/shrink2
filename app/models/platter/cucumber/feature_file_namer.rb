module Platter
  module Cucumber

    class FeatureFileNamer

      def self.name_for(feature)
        "#{feature.title.downcase.gsub(/\s/, '_').gsub(/\W/, '')}.feature"
      end

    end

  end
end
