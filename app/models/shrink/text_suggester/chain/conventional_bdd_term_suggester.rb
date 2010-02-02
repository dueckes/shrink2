module Shrink
  module TextSuggester
    module Chain

      class ConventionalBddTermSuggester

        class << self

          def suggestions_for(context)
            context.text.contains_complete_word? ? [] :
                    context.find_next_conventional_bdd_term_suggestions || context.configuration.first_bdd_term
          end

        end

      end

    end
  end
end
