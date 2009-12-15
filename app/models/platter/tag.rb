module Platter

  class Tag < ::ActiveRecord::Base
    include Platter::FeatureSummaryChangeObserver
    include Platter::Cucumber::Formatter::TagFormatter

    has_many :feature_tags, :class_name => "Platter::FeatureTag"
    has_many :features, :through => :feature_tags

    validates_presence_of :name
    validates_uniqueness_of :name
    validates_length_of :name, :maximum => 256

    alias_attribute :calculate_summary, :name

    def self.find_or_create!(attributes)
      find_by_name(attributes[:name]) || create!(attributes)
    end

  end
  
end
