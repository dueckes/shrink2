module Shrink
  module StepTextSuggester

    class ExistingStepTextSuggester

      def self.suggestions_for(context)
        context.text.contains_complete_word? ?
                context.project.steps.find_similar_texts(context.text, context.number_of_suggestions_allowed) : []
      end

    end

  end
end
