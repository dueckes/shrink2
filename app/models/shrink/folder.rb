module Shrink

  class Folder < ::ActiveRecord::Base
    acts_as_tree :order => :name
    belongs_to :project, :class_name => "Shrink::Project"
    has_many :features, :class_name => "Shrink::Feature", :order => :title, :dependent => :destroy

    validates_presence_of :name, :project
    validates_length_of :name, :maximum => 256
    validates_format_of :name, :with => /\A[0-9a-z_\-\s]*\Z/i
    validates_uniqueness_of :name, :scope => [:parent_id, :project_id], :allow_nil => true

    alias_method :parent_writer_without_project_assignment, :parent=
    def parent=(folder)
      self.project = folder.project if folder
      parent_writer_without_project_assignment(folder)
    end

    #TODO Candidate for tree plugin extension
    def tree_path
      ancestors.reverse + [self] - [self.root]
    end

    #TODO Candidate for tree plugin extension
    def directory_path
      tree_path.collect { |folder| folder.name }.join("/")
    end

    #TODO Candidate for tree plugin extension
    def root_sibling?
      parent == self.root
    end

    #TODO Candidate for tree plugin extension
    def root?
      self == self.root
    end

    #TODO Candidate for tree plugin extension
    def in_tree_path_until?(folder)
      self == folder || folder.ancestors.include?(self)
    end

    class << self

      def create_root_folder!(project)
        project.root_folder = self.create!(:name => "Root Folder", :project => project)
      end

      def find_or_create!(project, name_or_path)
        folder = project.root_folder
        name_or_path.as_folder_names.each do |folder_name|
          folder = self.find_or_create_by_name_and_parent!(folder_name, folder)
        end
        folder
      end

      def find_or_create_by_name_and_parent!(name, parent)
        folder = self.find_by_name_and_parent_id(name, parent)
        if folder.nil?
          folder = Shrink::Folder.create!(:name => name, :parent => parent)
        end
        folder
      end

    end

  end

end
