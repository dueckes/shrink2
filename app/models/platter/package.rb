module Platter

  class Package < ActiveRecord::Base
    acts_as_tree :order => :name
    has_many :features, :class_name => "Platter::Feature"

    validates_presence_of :name
  end

end
