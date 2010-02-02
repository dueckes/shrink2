module Shrink
  module TextSuggester

    class FeatureDescriptionLineSuggester < Shrink::TextSuggester::Base
      set_model_name :description_line
      set_conventional_bdd_suggestion_rules "As a", ["as a", ["And a", "I want to "] ],  ["i want to", ["So that I "] ] ,  ["so that I", ["And so that I "] ]
    end

  end
end
