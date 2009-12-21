module Platter
  module StepTextSuggester

    class Context
      attr_reader :text, :suggestions

      MAXIMUM_SUGGESTIONS = 10.freeze

      def initialize(text, position, scenario)
        @text = text
        @position = position
        @scenario = scenario
        @suggestions = []
      end

      def texts_before
        @scenario.steps[0..(@position - 1)].collect(&:text)
      end

      def add_suggestions(suggestions)
        @suggestions.concat(suggestions[0..(number_of_suggestions_allowed - 1)])
      end

      def number_of_suggestions_allowed
        MAXIMUM_SUGGESTIONS - suggestions.size
      end

      def more_suggestions_allowed?
        number_of_suggestions_allowed > 0
      end

    end

  end
end
