module Shrink
  module Cucumber

    class FeatureFileReader

      class << self

        def read(file)
          cucumber_ast_feature = ::Cucumber::FeatureFile.new(file).parse({}, {})
          cucumber_ast_feature.init
          Shrink::Feature.adapt(cucumber_ast_feature)
        end

      end

    end
  end
end
