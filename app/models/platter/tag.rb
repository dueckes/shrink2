module Platter

  class Tag < ::ActiveRecord::Base
    has_and_belongs_to_many :features, :class_name => "Platter::Feature", :order => :title

    validates_presence_of :name
    validates_uniqueness_of :name

    def self.find_or_create!(attributes)
      find_by_name(attributes[:name]) || create!(attributes)
    end
  end
  
end
