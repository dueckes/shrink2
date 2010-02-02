module Shrink
  module TextSuggester

    class Base

      class << self

        def set_model_name(name)
          @model_name = name
        end

        def set_conventional_bdd_suggestion_rules(*bdd_suggestion_rules)
          @bdd_suggestion_rules = bdd_suggestion_rules
        end

        def suggestions_for(text, position, parent_model)
          context = Shrink::TextSuggester::Context::Context.new(create_configuration, text, position, parent_model)
          Shrink::TextSuggester::Chain::SuggesterChain.suggestions_for(context)
        end

        private
        def create_configuration
          Shrink::TextSuggester::Context::Configuration.new(@model_name, @bdd_suggestion_rules)
        end

      end

    end

  end
end
