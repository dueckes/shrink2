class UsersController < ResourceApplicationController
  layout "users"

  before_filter :require_user
  before_filter :establish_all_models, :only => [:index, :show]
  before_filter :establish_all_roles, :only => [:index, :show, :update]
  before_filter :establish_model_via_id_param, :only => [:show, :update, :update_password, :destroy]

  filter_access_to :index
  filter_access_to :all, :attribute_check => true, :load_method => Proc.new { @user }

  set_create_errors_area_dom_id "new_project_errors"

  def index
    # Intentionally blank
  end

  def create
    super
    establish_all_models
  end

  # TODO Alias action that includes filters
  alias_method :update_password, :update

  private
  def establish_all_models
    @users = Shrink::User.find(:all, :order => "login desc")
  end

  def establish_all_roles
    @roles = Shrink::Role.find(:all, :order => "name desc")
  end

end
