module Platter

  class Feature < ActiveRecord::Base
    include Platter::Cucumber::Ast::FeatureConverter
    set_scenario_converter(Platter::Scenario)

    belongs_to :package, :class_name => "Platter::Package"
    has_many :lines, :class_name => "Platter::FeatureLine", :order => :position
    has_many :scenarios, :class_name => "Platter::Scenario", :order => :position

    validates_presence_of :package, :title

    def export base_dir
      file = Pathname.new(base_dir + "#{export_name}.feature")
      File.open(file, 'w') do | file_contents |
        file_contents.puts "Feature: #{title}"
        lines.each { | line | file_contents.puts "  #{line.text}" }
        scenarios.each do | scenario |
          file_contents.puts "Scenario: #{scenario.title}"
        end
      end
    end

    def export_name
      title.downcase.gsub(/\s/, '_').gsub(/\W/, '')
    end
  end

end
