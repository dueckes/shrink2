module Shrink

  class Scenario < ::ActiveRecord::Base
    include Shrink::FeatureSummaryChangeObserver
    include Shrink::Cucumber::Ast::Adapter::ScenarioAdapter
    include Shrink::Cucumber::Formatter::ScenarioFormatter
    include Shrink::Taggable

    set_step_adapter Shrink::Step

    belongs_to :feature, :class_name => "Shrink::Feature"
    has_many :steps, :class_name => "Shrink::Step", :order => :position, :dependent => :destroy

    acts_as_list :scope => :feature

    validates_presence_of :title
    validates_length_of :title, :maximum => 256
    validates_uniqueness_of :title, :scope => :feature_id

    def order_steps(ordered_step_ids)
      steps.each { |step| step.update_attributes(:position => ordered_step_ids.index(step.id) + self.class.first_position) }
      reload_steps
    end
    
    def folder
      feature.folder
    end

    def calculate_summary
      summary = "#{title}"
      steps.each do |step|
        summary << "\n" unless step.text_type?
        summary << "\n#{step.calculate_summary}"
      end
      summary
    end

    private
    def reload_steps
      steps(true)
    end

  end

end
