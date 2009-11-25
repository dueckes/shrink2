module Platter

  class Step < ::ActiveRecord::Base
    include Platter::Cucumber::Ast::StepConverter

    belongs_to :scenario, :class_name => "Platter::Scenario"
    acts_as_list :scope => :scenario

    validates_presence_of :scenario, :text
    validates_length_of :text, :maximum => 255

    def feature
      scenario.feature
    end

    def package
      scenario.package
    end

    def as_text
      text
    end
  end

end
