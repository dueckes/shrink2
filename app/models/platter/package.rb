module Platter

  class Package < ActiveRecord::Base
    acts_as_tree :order => :name
    has_many :features, :class_name => "Platter::Feature"

    validates_length_of :name, :maximum => 256

    class << self

      def find_or_create!(name_or_path)
        package = self.root
        name_or_path.as_directory_names.each do |package_name|
          package = self.find_or_create_by_name_and_parent!(package_name, package)
        end
        package
      end

      def find_or_create_by_name_and_parent!(name, parent)
        package = self.find_by_name_and_parent_id(name, parent)
        if package.nil?
          package = Platter::Package.create!(:name => name, :parent => parent)
        end
        package
      end

    end

  end

end
