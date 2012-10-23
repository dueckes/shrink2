module Shrink

  class FeatureDescriptionLine < ::ActiveRecord::Base
    include Shrink::FeatureSummaryChangeObserver
    include Shrink::Cucumber::Formatter::TextFormatter

    set_short_name :description_line

    belongs_to :feature, :class_name => "Shrink::Feature"
    acts_as_list :scope => :feature

    validates_presence_of :text
    validates_length_of :text, :maximum => 256

    alias_attribute :calculate_summary, :text

    def folder
      feature.folder
    end

  end

end
