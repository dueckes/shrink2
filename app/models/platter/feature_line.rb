module Platter

  class FeatureLine < ActiveRecord::Base
    belongs_to :feature, :class_name => "Platter::Feature"
    acts_as_list :scope => :feature

    validates_presence_of :text
  end

end
