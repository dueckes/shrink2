module Shrink
  module Cucumber

    class FeatureFileReader

      class << self

        def read(file)
          cucumber_ast_feature = Shrink::Cucumber::StepMotherFactory.create.load_plain_text_features([file])[0]
          cucumber_ast_feature.init
          Shrink::Feature.adapt(cucumber_ast_feature)
        end

      end

    end
  end
end
