module Platter

  class Feature < ::ActiveRecord::Base
    include Platter::Cucumber::Ast::FeatureConverter
    set_scenario_converter Platter::Scenario

    belongs_to :package, :class_name => "Platter::Package"
    has_many :lines, :class_name => "Platter::FeatureLine", :order => :position
    has_many :scenarios, :class_name => "Platter::Scenario", :order => :position

    validates_presence_of :package, :title
    validates_length_of :title, :maximum => 255
    validates_uniqueness_of :title, :scope => :package_id

    UPLOAD_DIRECTORY = "#{RAILS_ROOT}/tmp/uploaded_features".freeze

    def in_package_hierarchy?(package)
      package.in_hierarchy?(self.package)
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

  end

end
