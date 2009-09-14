module Platter

  class Step < ActiveRecord::Base
    belongs_to :scenario, :class_name => "Platter::Scenario"
    acts_as_list :scope => :scenario

    validates_presence_of :text
  end

end
