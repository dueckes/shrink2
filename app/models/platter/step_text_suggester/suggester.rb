module Platter
  module StepTextSuggester

    class Suggester
      
      SUGGESTER_CHAIN = [Platter::StepTextSuggester::ConventionalBddTermSuggester,
                         Platter::StepTextSuggester::ExistingStepTextSuggester]

      def self.suggestions_for(text, position, scenario)
        context = Platter::StepTextSuggester::Context.new(text, position, scenario)
        SUGGESTER_CHAIN.each do |suggester|
          context.add_suggestions(suggester.suggestions_for(context)) if context.more_suggestions_allowed?
        end
        context.suggestions
      end

    end

  end
end
