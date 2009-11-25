module Platter

  class Tag < ::ActiveRecord::Base
    validates_presence_of :name

    def self.find_or_create!(attributes)
      find_by_name(attributes[:name]) || create!(attributes)
    end
  end
  
end
