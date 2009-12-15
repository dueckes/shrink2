module Platter

  class Folder < ::ActiveRecord::Base
    acts_as_tree :order => :name
    has_many :features, :class_name => "Platter::Feature", :order => :title

    validates_presence_of :name
    validates_length_of :name, :maximum => 256
    validates_uniqueness_of :name, :scope => :parent_id

    #TODO Candidate for tree plugin extension
    def tree_path
      ancestors.reverse - [self.root] + [self]
    end

    #TODO Candidate for tree plugin extension
    def root_sibling?
      parent == self.root
    end

    def root?
      parent == nil
    end

    def in_tree_path_until?(folder)
      self == folder || folder.ancestors.include?(self)
    end

    class << self

      def find_or_create!(name_or_path)
        folder = self.root
        name_or_path.as_folder_names.each do |directory_name|
          folder = self.find_or_create_by_name_and_parent!(directory_name, folder)
        end
        folder
      end

      def find_or_create_by_name_and_parent!(name, parent)
        folder = self.find_by_name_and_parent_id(name, parent)
        if folder.nil?
          folder = Platter::Folder.create!(:name => name, :parent => parent)
        end
        folder
      end

    end

  end

end
