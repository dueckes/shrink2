module Platter
  module FeatureSummaryChangeObserver

    def self.included(model_class)
      model_class.send(:include, InstanceMethods)
      model_class.after_save { |model| model.update_feature_summaries! }
      model_class.after_destroy { |model| model.update_feature_summaries! }
    end

    module InstanceMethods

      def update_feature_summaries!
        if self.respond_to?(:features)
          features(true)
          features.each(&:update_summary!)
        else
          feature.update_summary!
        end
      end

    end

  end
end
