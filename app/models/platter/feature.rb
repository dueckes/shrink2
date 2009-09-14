module Platter

  class Feature < ActiveRecord::Base
    belongs_to :package, :class_name => "Platter::Package"
    has_many :lines, :class_name => "Platter::FeatureLine", :order => :position
    has_many :scenarios, :class_name => "Platter::Scenario", :order => :position

    validates_presence_of :package, :title
  end

end
