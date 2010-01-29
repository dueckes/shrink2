module Shrink
  module FeatureSummaryChangeObserver

    def self.included(model_class)
      model_class.extend(ClassMethods)
      model_class.send(:include, InstanceMethods)
    end

    module ClassMethods

      def set_observed_callback_methods(*callback_methods)
        @observed_callback_methods = callback_methods
      end

      def observed_callback_methods
        @observed_callback_methods || [:save, :destroy]
      end

    end

    module InstanceMethods

      def before_save_commit_when_first_transaction_participant
        associated_features.each(&:update_summary!) if self.class.observed_callback_methods.include?(:save)
      end

      def before_destroy_commit_when_first_transaction_participant
        associated_features.each(&:update_summary!) if self.class.observed_callback_methods.include?(:destroy)
      end

      private
      def associated_features
        if self.respond_to?(:features)
          features(true)
          features
        else
          [feature]
        end

      end

    end

  end
end
