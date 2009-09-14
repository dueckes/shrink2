module Platter

  class Scenario < ActiveRecord::Base
    belongs_to :feature, :class_name => "Platter::Feature"
    has_many :steps, :class_name => "Platter::Step", :order => :position
    acts_as_list :scope => :feature

    validates_presence_of :title

    def package
      feature.package
    end
    
  end

end
