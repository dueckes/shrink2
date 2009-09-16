module Platter
  module Cucumber

    class FeatureFileReader

      class << self

        def read_files(files)
          cucumber_ast_features = create_step_mother.load_plain_text_features(files)
          cucumber_ast_features.collect { |cucumber_ast_feature| Platter::Feature.from(cucumber_ast_feature) }
        end

        private
        def create_step_mother
          step_mother = ::Cucumber::StepMother.new
          step_mother.log = SilentLog.new
          step_mother
        end
        
      end

    end
  end
end
