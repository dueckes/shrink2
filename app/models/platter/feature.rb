module Platter

  class Feature < ::ActiveRecord::Base
    include Platter::Cucumber::Ast::FeatureConverter
    set_scenario_converter Platter::Scenario

    belongs_to :package, :class_name => "Platter::Package"
    has_many :lines, :class_name => "Platter::FeatureLine", :order => :position
    has_many :scenarios, :class_name => "Platter::Scenario", :order => :position
    has_and_belongs_to_many :tags, :class_name => "Platter::Tag", :order => :name

    validates_presence_of :package, :title
    validates_length_of :title, :maximum => 255
    validates_uniqueness_of :title, :scope => :package_id

    UPLOAD_DIRECTORY = "#{RAILS_ROOT}/tmp/uploaded_features".freeze

    def tag_line
      tags.collect(&:name).join(", ")
    end

    def tag_line=(tag_line)
      tag_names = tag_line.split(",").collect(&:strip).uniq
      add_tags(tag_names)
      remove_tags(tag_names)
    end

    def unused_tags
      Tag.find(:all, :order => "name") - tags
    end

    def as_text
      text_lines = []
      text_lines << "Feature: #{title}"
      lines.map(&:as_text).each { |line_text| text_lines << "  #{line_text}" }
      scenario_lines = scenarios.map(&:as_text)
      text_lines << scenario_lines.join("\n\n") 
      text_lines.join("\n")
    end
    
    def export(base_dir)
      file = Pathname.new(base_dir + "#{export_name}.feature")
      File.open(file, 'w') do | file_contents |
        file_contents << as_text
      end
    end

    def export_name
      title.downcase.gsub(/\s/, '_').gsub(/\W/, '')
    end

    private
    def add_tags (tag_names)
      feature_tag_names = tags.collect(&:name)
      added_tag_names = tag_names.find_all { |tag_name| !feature_tag_names.include?(tag_name) }
      added_tag_names.each { |tag_name| tags << Platter::Tag.find_or_create!(:name => tag_name) }
    end

    def remove_tags(tag_names)
      removed_tags = tags.find_all { |tag| !tag_names.include?(tag.name) }
      removed_tags.each { |tag| tags.delete(tag) }
    end

  end

end
