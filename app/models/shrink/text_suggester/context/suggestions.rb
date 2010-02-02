module Shrink
  module TextSuggester
    module Context

      class Suggestions

        MAXIMUM = 10.freeze

        def initialize
          @suggestions = []
        end

        def add(suggestions)
          suggestion_array = suggestions.is_a?(Array) ? suggestions : [suggestions]
          @suggestions.concat(suggestion_array[0, number_allowed])
        end

        def number_allowed
          MAXIMUM - @suggestions.size
        end

        def more_allowed?
          number_allowed > 0
        end

        def to_a
          Array.new(@suggestions)
        end

      end

    end
  end
end
