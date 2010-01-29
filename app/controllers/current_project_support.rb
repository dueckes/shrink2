module CurrentProjectSupport

  def self.included(controller_class)
    controller_class.helper_method :current_project
    controller_class.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def current_project
      @current_project ||= Shrink::Project.find(session[:current_project_id])
    end

    def store_current_project(id)
      session[:current_project_id] = id
    end

  end

end
