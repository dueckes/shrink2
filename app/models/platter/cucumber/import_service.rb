module Platter
  module Cucumber

    class ImportService

      class << self

        def import_file(file_path)
          cucumber_ast_features = create_step_mother.load_plain_text_features([file_path])
          features = cucumber_ast_features.collect { |cucumber_ast_feature| Platter::Feature.from(cucumber_ast_feature) }
          features.empty? ? [] : features.first
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
