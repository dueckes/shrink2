module Platter
  module StepSuggester

    class IncompleteFirstWordTextSuggester

      ORDERED_WORD_RULES = [ ["then", %w(And)],  ["when", %w(And Then)], ["given", %w(And When)] ]

      class << self

        def suggestions_for(context)
          context.text.contains_complete_word? ? [] :
                  (matching_rule = evaluate_matching_rule(context)) ? matching_rule[1] : ["Given"] 
        end

        private
        def evaluate_matching_rule(context)
          prior_first_words = first_words_before(context)
          ORDERED_WORD_RULES.detect { |rule| prior_first_words.match(/\b#{Regexp.escape(rule[0])}\b/) }
        end

        def first_words_before (context)
          context.texts_before.collect { |text| text.match(/^\w*/)[0].downcase }.join(" ")
        end

      end

    end

  end
end
