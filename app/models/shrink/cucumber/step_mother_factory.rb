module Shrink
  module Cucumber

    class StepMotherFactory

      class << self

        def create
          step_mother = ::Cucumber::StepMother.new
          step_mother.options = create_options
          step_mother.log = SilentLog
          step_mother
        end

        private

        def create_options
          options = ::Cucumber::Cli::Options.new
          options[:tag_expression] = ::Gherkin::TagExpression.new([])
          options
        end

      end

    end

  end
end
