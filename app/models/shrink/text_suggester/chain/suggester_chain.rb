module Shrink
  module TextSuggester
    module Chain

      class SuggesterChain

        SUGGESTERS = [Shrink::TextSuggester::Chain::ConventionalBddTermSuggester,
                      Shrink::TextSuggester::Chain::ExistingTextSuggester]

        def self.suggestions_for(context)
          SUGGESTERS.each do |suggester|
            context.suggestions.add(suggester.suggestions_for(context)) if context.suggestions.more_allowed?
          end
          context.suggestions.to_a
        end

      end

    end
  end
end
