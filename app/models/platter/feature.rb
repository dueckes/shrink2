module Platter

  class Feature < ActiveRecord::Base
    belongs_to :package, :class_name => "Platter::Package"
    has_many :lines, :class_name => "Platter::FeatureLine", :order => :position
    has_many :scenarios, :class_name => "Platter::Scenario", :order => :position

    validates_presence_of :package, :title

    def export base_dir
      file = Pathname.new(base_dir + "#{title}.feature")
      File.open(file, 'w') do | file_contents |
        file_contents << "blah"
      end
    end
  end

end
