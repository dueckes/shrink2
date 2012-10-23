module Shrink
  module TextSuggester
    module Context

      class Context
        attr_reader :configuration, :text, :suggestions

        MAXIMUM_SUGGESTIONS = 10.freeze

        def initialize(configuration, text, position, parent_model)
          @configuration = configuration
          @text = text
          @position = position
          @parent_model = parent_model
          @suggestions = Shrink::TextSuggester::Context::Suggestions.new
        end

        def find_next_conventional_bdd_term_suggestions
          @configuration.find_next_conventional_bdd_term_suggestions(texts_before)
        end

        def find_similar_existing_texts
          @configuration.models_in(project).find_similar_texts(@text, @suggestions.number_allowed)
        end

        private
        def texts_before
          @configuration.models_in(@parent_model)[0, @position].collect(&:text).compact
        end

        def project
          @parent_model.feature.project
        end

      end

    end
  end
end
