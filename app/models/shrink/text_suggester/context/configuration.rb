module Shrink
  module TextSuggester
    module Context

      class Configuration

        def initialize(model_name, bdd_suggestion_rules)
          @model_name = model_name
          @bdd_suggestion_rules = bdd_suggestion_rules
        end

        def first_bdd_term
          @bdd_suggestion_rules[0]
        end

        def bdd_term_rules
          @bdd_suggestion_rules[1..-1]
        end

        def models_in(model)
          model.send(@model_name.to_s.pluralize)
        end

        def find_next_conventional_bdd_term_suggestions(texts)
          rule = bdd_term_rules.reverse.detect do |rule|
            texts.detect { |text| text.match(/^#{Regexp.escape(rule[0])}/i) }
          end
          rule ? rule[1] : nil
        end

      end

    end
  end
end
