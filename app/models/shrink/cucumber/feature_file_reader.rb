module Shrink
  module Cucumber

    class FeatureFileReader

      class << self

        def read(file)
          cucumber_ast_feature = create_step_mother.load_plain_text_features([file])[0]
          Shrink::Feature.adapt(cucumber_ast_feature)
        end

        private
        def create_step_mother
          step_mother = ::Cucumber::StepMother.new
          step_mother.log = SilentLog
          step_mother
        end
        
      end

    end
  end
end
