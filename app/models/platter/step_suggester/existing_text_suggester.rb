module Platter
  module StepSuggester

    class ExistingTextSuggester

      def self.suggestions_for(context)
        context.text.contains_complete_word? ? find_similar_step_text(context) : []
      end

      def self.find_similar_step_text(context)
        # TODO Script injection protection, find() approach?
        Platter::Step.find_by_sql(%{SELECT DISTINCT(text) from #{Platter::Step.table_name}
                                    WHERE LOWER(text) LIKE LOWER('#{context.text}%')
                                    ORDER BY text ASC
                                    LIMIT 10} ).collect(&:text)
      end

    end

  end
end
