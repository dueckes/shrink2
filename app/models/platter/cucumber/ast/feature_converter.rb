module Platter
  module Cucumber
    module Ast

      class FeatureConverter

        def initialize(cucumber_ast_feature)
          @cucumber_ast_feature = cucumber_ast_feature
        end

        def convert
          feature = Platter::Feature.new(:title => parse_title)
          parse_lines.each { |parsed_line| feature.lines << parsed_line }
          feature
        end

        private
        def parse_title
          title = (colon_match = lines.first.match(/:(.*)$/)) ? colon_match[1] : lines.first
          title.strip
        end

        def parse_lines
          lines[1..-1].collect { |line| Platter::FeatureLine.new(:text => line.strip) }
        end

        def lines
          @lines ||= @cucumber_ast_feature.name.split("\n").collect(&:strip)
        end

      end

    end
  end
end
