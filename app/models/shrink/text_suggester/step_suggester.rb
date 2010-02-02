module Shrink
  module TextSuggester

    class StepSuggester < Shrink::TextSuggester::Base
      set_model_name :step
      set_conventional_bdd_suggestion_rules "Given", ["given", %w(And When)], ["when", %w(And Then)], ["then", %w(And)]
    end

  end
end
