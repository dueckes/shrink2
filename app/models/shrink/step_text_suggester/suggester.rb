module Shrink
  module StepTextSuggester

    class Suggester
      
      SUGGESTER_CHAIN = [Shrink::StepTextSuggester::ConventionalBddTermSuggester,
                         Shrink::StepTextSuggester::ExistingStepTextSuggester]

      def self.suggestions_for(text, position, scenario)
        context = Shrink::StepTextSuggester::Context.new(text, position, scenario)
        SUGGESTER_CHAIN.each do |suggester|
          context.add_suggestions(suggester.suggestions_for(context)) if context.more_suggestions_allowed?
        end
        context.suggestions
      end

    end

  end
end
