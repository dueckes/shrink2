module Platter
  module Cucumber
    module Ast

      module FeatureConverter

        def self.included(obj)
          obj.extend(ClassMethods)
        end

        module ClassMethods

          def set_scenario_converter(converter)
            @scenario_converter = converter
          end

          def scenario_converter
            raise "scenario_converter must be established" if !@scenario_converter
            @scenario_converter
          end

          def from(cucumber_ast_feature)
            parser = FeatureParser.new(cucumber_ast_feature)
            feature = Platter::Feature.new(:title => parser.title)
            feature.lines.concat(
                    parser.lines_text.collect { |line_text| Platter::FeatureLine.new(:text => line_text) })
            feature.scenarios.concat(
                    cucumber_ast_feature.feature_elements.collect { |scenario| scenario_converter.from(scenario) })
            feature
          end

        end
        
      end

    end
  end
end
