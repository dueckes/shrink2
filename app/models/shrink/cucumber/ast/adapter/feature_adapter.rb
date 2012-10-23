module Shrink
  module Cucumber
    module Ast
      module Adapter

        module FeatureAdapter

          def self.included(obj)
            obj.extend(ClassMethods)
            obj.mandatory_cattr_accessor :scenario_adapter, :tag_adapter
          end

          module ClassMethods

            def adapt(cucumber_ast_feature)
              parser = FeatureParser.new(cucumber_ast_feature)
              feature = Shrink::Feature.new(:title => parser.title)
              feature.tags.concat(
                      parser.raw_tag_names.collect { |raw_tag_name| tag_adapter.adapt(raw_tag_name) })
              feature.description_lines.concat(
                      parser.text_lines.collect { |text_line| Shrink::FeatureDescriptionLine.new(:text => text_line) })
              feature.scenarios.concat(
                      cucumber_ast_feature.feature_elements.collect { |scenario| scenario_adapter.adapt(scenario) })
              feature
            end

          end

        end

      end
    end
  end
end
