module Platter
  module StepSuggester

    class StepSuggester
      
      SUGGESTER_CHAIN = [Platter::StepSuggester::IncompleteFirstWordTextSuggester,
                         Platter::StepSuggester::ExistingTextSuggester]

      def self.suggestions_for(text, position, scenario)
        context = Platter::StepSuggester::Context.new(text, position, scenario)
        SUGGESTER_CHAIN.collect { |suggester| suggester.suggestions_for(context) }.flatten
      end

    end

  end
end
