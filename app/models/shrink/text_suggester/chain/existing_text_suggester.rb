module Shrink
  module TextSuggester
    module Chain

      class ExistingTextSuggester

        def self.suggestions_for(context)
          context.text.contains_complete_word? ? context.find_similar_existing_texts : []
        end

      end

    end
  end
end
