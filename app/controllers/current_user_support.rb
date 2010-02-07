module CurrentUserSupport

  def self.included(controller_class)
    controller_class.helper_method :current_user_session, :current_user
    controller_class.before_filter :set_authorization_current_user
    controller_class.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def current_user_session
      @current_user_session ||= Shrink::UserSession.find
    end

    def current_user
      @current_user ||= current_user_session && current_user_session.user
    end

    def set_authorization_current_user
      Authorization.current_user = current_user
    end

    def require_user
      unless current_user
        store_current_path
        flash[:message] = "You must sign on to access this page"
        redirect_to(sign_in_url)
        return false
      end
    end

    def with_current_user_required(&block)
      return false unless require_user != false
      block.call(current_user)
    end
  
    def require_no_user
      if current_user
        store_current_path
        flash[:message] = "You must sign off to access this page"
        redirect_to(user_url(current_user))
        return false
      end
    end

    def store_current_path
      session[:stored_path] = request.request_uri
    end

    def redirect_to_stored_path_or(path)
      redirect_to(stored_path_or(path))
      clear_stored_path
    end

    private
    def stored_path_or(path)
      session[:stored_path] || path
    end

    def clear_stored_path
      session[:stored_path] = nil
    end

  end

end
