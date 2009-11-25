module Platter

  class Scenario < ::ActiveRecord::Base
    include Platter::Cucumber::Ast::ScenarioConverter
    set_step_converter(Platter::Step)

    belongs_to :feature, :class_name => "Platter::Feature"
    has_many :steps, :class_name => "Platter::Step", :order => :position
    acts_as_list :scope => :feature

    validates_presence_of :feature, :title
    validates_length_of :title, :maximum => 255
    validates_uniqueness_of :title, :scope => :feature_id

    def package
      feature.package
    end

    def as_text
      puts steps.first.as_text unless steps.empty?
      text_lines = []
      text_lines << "Scenario: #{title}"
      steps.map(&:as_text).each { |step_text| text_lines << "  #{step_text}"}
      text_lines.join("\n")
    end
  end

end
