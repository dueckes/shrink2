module Platter
  module StepSuggester

    class Context
      attr_reader :text

      def initialize(text, position, scenario)
        @text = text
        @position = position
        @scenario = scenario
      end

      def texts_before
        @scenario.steps[0..(@position - 1)].collect(&:text)
      end

    end

  end
end
