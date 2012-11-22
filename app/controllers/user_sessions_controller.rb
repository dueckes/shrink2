class UserSessionsController < ApplicationController
  layout "unsecure", :only => [:new, :create]

  before_filter :require_no_user, :only => :create
  before_filter :require_user, :only => :destroy

  def new
    @user_session = Shrink::UserSession.new
  end

  def create
    @user_session = Shrink::UserSession.new(params[:user_session])
    @user_session.save
    respond_to do |format|
      format.html { create_html_response }
      format.js { create_js_response }
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to(root_path)
  end

  private
  def create_html_response
    @user_session.valid? ? redirect_to_stored_path_or(projects_path) : render(:action => :new)
  end

  def create_js_response
    render :js => "window.location = '#{projects_url}'" if @user_session.valid?
  end

end
