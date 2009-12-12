module Platter

  class Scenario < ::ActiveRecord::Base
    include Platter::FeatureSummaryChangeObserver
    include Platter::Cucumber::Adapter::AstScenarioAdapter
    include Platter::Cucumber::Formatter::ScenarioFormatter
    set_step_adapter Platter::Step

    belongs_to :feature, :class_name => "Platter::Feature"
    has_many :steps, :class_name => "Platter::Step", :order => :position
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

    def summarize
      [title, steps.collect { |step| "  #{step.summarize}" }].join("\n")
    end

    private
    def reload_steps
      steps(true)
    end

  end

end
