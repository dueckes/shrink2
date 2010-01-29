module Shrink

  class Feature < ::ActiveRecord::Base
    include Shrink::FeatureSummaryChangeObserver
    include Shrink::Cucumber::Adapter::AstFeatureAdapter
    include Shrink::Cucumber::Formatter::FeatureFormatter

    set_observed_callback_methods :save
    set_scenario_adapter Shrink::Scenario

    belongs_to :project, :class_name => "Shrink::Project"
    belongs_to :folder, :class_name => "Shrink::Folder"
    has_many :description_lines, :class_name => "Shrink::FeatureDescriptionLine", :order => :position, :dependent => :destroy
    has_many :scenarios, :class_name => "Shrink::Scenario", :order => :position, :dependent => :destroy
    has_many :feature_tags, :class_name => "Shrink::FeatureTag", :dependent => :destroy
    has_many :tags, :through => :feature_tags, :order => :name, :extend => Shrink::FeatureTags

    validates_presence_of :project, :folder, :title
    validates_length_of :title, :maximum => 256
    validates_uniqueness_of :title, :scope => :folder_id

    SUMMARIZED_ASSOCIATIONS = [:tags, :description_lines, :scenarios]

    #TODO Modify belongs_to to include/exclude parent associations
    def self.parent_associations
      super.select { |association| association.name != :project }
    end

    alias_method :project_writer_without_feature_tags_project_assignment, :project=
    def project=(project)
      self.tags.project = project
      project_writer_without_feature_tags_project_assignment(project)
    end

    alias_method :folder_writer_without_project_assignment, :folder=
    def folder=(folder)
      self.project = folder.project if folder
      folder_writer_without_project_assignment(folder)
    end

    def search_result_preview(search_text)
      summary.preview(search_text, 1)
    end

    def calculate_summary
      header = [title, tags.collect(&:calculate_summary).join(" "),
                description_lines.collect(&:calculate_summary)].flatten.join("\n")
      [header, scenarios.collect(&:calculate_summary)].join("\n\n")
    end

    def update_summary!
      reload_summary_associations
      update_attributes!(:summary => calculate_summary)
    end

    def base_filename
      title.fileize
    end

    def feature
      self
    end

    private
    def reload_summary_associations
      SUMMARIZED_ASSOCIATIONS.each { |association| self.send(association, true) }
    end

  end

end
