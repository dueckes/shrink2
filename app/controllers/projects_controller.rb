class ProjectsController < ResourceApplicationController
  layout "projects"

  before_filter :require_user
  before_filter :establish_all_models, :only => [:index, :show]
  
  filter_access_to :all

  set_create_errors_area_dom_id "new_project_errors"

  def index
    # Intentionally blank
  end

  def show
    @model_classes = [Shrink::Folder, Shrink::Feature, Shrink::Tag]
    @recently_changed_features = @project.features.most_recently_changed(5)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    super
    establish_all_models
  end

  private
  def establish_all_models
    @projects = Shrink::Project.order("name desc")
  end

end
