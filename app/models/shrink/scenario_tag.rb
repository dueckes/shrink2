 module Shrink

  class ScenarioTag < ::ActiveRecord::Base
    belongs_to :scenario, :class_name => "Shrink::Scenario"
    belongs_to :tag, :class_name => "Shrink::Tag"
  end

end
