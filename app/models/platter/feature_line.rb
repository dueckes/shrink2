module Platter

  class FeatureLine < ::ActiveRecord::Base
    include Platter::FeatureSummaryChangeObserver
    include Platter::Cucumber::Formatter::TextFormatter

    belongs_to :feature, :class_name => "Platter::Feature"
    acts_as_list :scope => :feature

    validates_presence_of :text
    validates_length_of :text, :maximum => 256

    alias_attribute :summarize, :text

    def package
      feature.package
    end

  end

end
