module Shrink

  class User < ::ActiveRecord::Base
    belongs_to :role, :class_name => "Shrink::Role"
    has_many :user_projects, :class_name => "Shrink::ProjectUser", :dependent => :destroy
    has_many :projects, :through => :user_projects

    validates_presence_of :role

    acts_as_authentic do |config|
      config.logged_in_timeout = 30.minutes
      config.ignore_blank_passwords = false
    end

    #TODO Modify belongs_to to include/exclude parent associations
    def self.parent_associations
      []
    end

    def role_symbols
      [role.name.to_sym]
    end

  end

end
