module Shrink
  module Cucumber
    module Ast

      class FeatureParser

        def initialize(cucumber_ast_feature)
          @cucumber_ast_feature = cucumber_ast_feature
        end

        def raw_tag_names
          @cucumber_ast_feature.source_tag_names
        end

        def title
          title = (colon_match = lines.first.match(/:(.*)$/)) ? colon_match[1] : lines.first
          title.strip
        end

        def text_lines
          lines[1..-1].collect(&:strip)
        end

        private
        def lines
          @lines ||= @cucumber_ast_feature.name.split("\n").collect(&:strip)
        end

      end

    end
  end
end
