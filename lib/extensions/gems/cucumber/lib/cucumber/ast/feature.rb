module Shrink
  module Cucumber
    module Ast
      module Feature

        def self.included(feature)
          feature.instance_eval do
            attr_reader :feature_elements
          end
        end

      end
    end
  end
end
