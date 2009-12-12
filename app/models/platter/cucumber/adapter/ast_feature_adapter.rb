module Platter
  module Cucumber
    module Adapter

      module AstFeatureAdapter

        def self.included(obj)
          obj.extend(ClassMethods)
        end

        module ClassMethods

          def set_scenario_adapter(adapter)
            @scenario_adapter = adapter
          end

          def scenario_adapter
            raise "scenario_adapter must be established" unless @scenario_adapter
            @scenario_adapter
          end

          def adapt(cucumber_ast_feature)
            parser = AstFeatureParser.new(cucumber_ast_feature)
            feature = Platter::Feature.new(:title => parser.title)
            feature.tags.concat(
                    parser.tag_names.collect { |tag_name| Platter::Tag.find_or_create!(:name => tag_name) })
            feature.lines.concat(
                    parser.lines_text.collect { |line_text| Platter::FeatureLine.new(:text => line_text) })
            feature.scenarios.concat(
                    cucumber_ast_feature.feature_elements.collect { |scenario| scenario_adapter.adapt(scenario) })
            feature
          end

        end
        
      end

    end
  end
end
