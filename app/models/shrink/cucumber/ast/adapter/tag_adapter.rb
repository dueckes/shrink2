module Shrink
  module Cucumber
    module Ast
      module Adapter

        class TagAdapter

          class << self

            def adapt(raw_tag)
              Shrink::Tag.new(:name => raw_tag.gsub(/^@/, ""))
            end

          end

        end

      end
    end
  end
end
