module Shrink

  class Tag < ::ActiveRecord::Base
    include Shrink::FeatureSummaryChangeObserver
    include Shrink::Cucumber::Formatter::TagFormatter

    belongs_to :project, :class_name => "Shrink::Project"
    has_many :feature_tags, :class_name => "Shrink::FeatureTag"
    has_many :features, :through => :feature_tags

    validates_presence_of :name
    validates_length_of :name, :maximum => 256
    validates_uniqueness_of :name, :scope => :project_id

    alias_attribute :calculate_summary, :name

    def self.find_or_new(attributes)
      find_or_block(attributes) { new(attributes) }
    end

    def self.find_or_create!(attributes)
      find_or_block(attributes) { create!(attributes) }
    end

    private
    def self.find_or_block(attributes, &block)
      find_by_project_id_and_name(attributes[:project], attributes[:name]) || block.call(attributes)
    end

  end
  
end
