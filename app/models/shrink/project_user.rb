module Shrink

  class ProjectUser < ::ActiveRecord::Base
     belongs_to :project, :class_name => "Shrink::Project"
     belongs_to :user, :class_name => "Shrink::User"
  end

end
