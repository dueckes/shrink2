module Platter

  class Feature < ::ActiveRecord::Base
    include Platter::Cucumber::Adapter::AstFeatureAdapter
    include Platter::Cucumber::Formatter::FeatureFormatter
    set_scenario_adapter Platter::Scenario

    belongs_to :package, :class_name => "Platter::Package"
    has_many :description_lines, :class_name => "Platter::FeatureDescriptionLine", :order => :position
    has_many :scenarios, :class_name => "Platter::Scenario", :order => :position
    has_many :feature_tags, :class_name => "Platter::FeatureTag"
    has_many :tags, :through => :feature_tags, :order => :name

    validates_presence_of :package, :title
    validates_length_of :title, :maximum => 256
    validates_uniqueness_of :title, :scope => :package_id

    before_save { |feature| feature.summary = feature.summarize unless feature.updating_summary? }

    UPLOAD_DIRECTORY = "#{RAILS_ROOT}/tmp/uploaded_features".freeze
    SUMMARIZED_ASSOCIATIONS = [:tags, :description_lines, :scenarios]

    def tag_line
      tags.collect(&:name).join(", ")
    end

    def tag_line=(tag_line)
      tag_names = tag_line.split(",").collect(&:strip).uniq
      add_tags(tag_names)
      remove_tags(tag_names)
      update_summary!
    end

    def unused_tags
      Tag.find(:all, :order => "name") - tags
    end

    def search_result_preview_lines(search_text)
      summary_lines = summary.split("\n").delete_if(&:empty?)
      matching_line_position = summary_lines.find_index { |summary_line| summary_line.match(/#{Regexp.escape(search_text)}/i) }
      summary_lines.preview(matching_line_position, 3, "...")
    end

    def summarize
      header = [title, tags.collect(&:summarize).join(" "),
                description_lines.collect { |line| "  #{line.summarize}" }].flatten.join("\n")
      [header, scenarios.collect(&:summarize)].join("\n\n")
    end

    def update_summary!
      @updating_summary = true
      reload_summary_associations
      update_attributes!(:summary => summarize)
      @updating_summary = false
    end

    def updating_summary?
      @updating_summary
    end

    private
    def add_tags(tag_names)
      feature_tag_names = tags.collect(&:name)
      added_tag_names = tag_names.find_all { |tag_name| !feature_tag_names.include?(tag_name) }
      added_tag_names.each { |tag_name| tags << Platter::Tag.find_or_create!(:name => tag_name) }
    end

    def remove_tags(tag_names)
      removed_tags = tags.find_all { |tag| !tag_names.include?(tag.name) }
      removed_tags.each { |tag| tags.delete(tag) }
    end

    def reload_summary_associations
      SUMMARIZED_ASSOCIATIONS.each { |association| self.send(association, true) }
    end

  end

end
