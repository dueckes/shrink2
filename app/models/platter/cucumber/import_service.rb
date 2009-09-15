module Platter
  module Cucumber

    class ImportService

      def self.import_file(file_path)
        features = []
        step_mother = ::Cucumber::StepMother.new
        step_mother.log = SilentLog.new
        cucumber_ast_features = step_mother.load_plain_text_features([file_path])
        cucumber_ast_features.each do |cucumber_ast_feature|
          features << Platter::Cucumber::Ast::FeatureConverter.new(cucumber_ast_feature).convert
        end
        features.first
      end

    end

  end
end
