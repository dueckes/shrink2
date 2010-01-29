module Shrink

  class Project < ::ActiveRecord::Base
    has_one :root_folder, :class_name => "Shrink::Folder", :dependent => :destroy
    has_many :project_users, :class_name => "Shrink::ProjectUser", :dependent => :destroy
    has_many :users, :through => :project_users
    has_many :folders, :class_name => "Shrink::Folder", :extend => Shrink::ProjectFolders, :dependent => :destroy
    has_many :features, :class_name => "Shrink::Feature", :extend => Shrink::ProjectFeatures
    has_many :tags, :class_name => "Shrink::Tag", :extend => Shrink::ProjectTags, :dependent => :destroy

    validates_presence_of :name
    validates_length_of :name, :maximum => 256
    validates_uniqueness_of :name

    after_create { |project| Shrink::Folder.create_root_folder!(project) }

    def steps
      @steps ||= Shrink::ProjectSteps.new(self)
    end

  end

end
