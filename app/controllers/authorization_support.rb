module AuthorizationSupport

  def self.included(controller)
    controller.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def permission_denied
      flash[:error] = 'Sorry, you are not allowed to this page.'
      respond_to do |format|
        format.html { redirect_to(unauthorized_url) }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    end

  end

end
