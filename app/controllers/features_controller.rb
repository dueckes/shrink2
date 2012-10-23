class FeaturesController < ResourceApplicationController
  layout "features", :only => [:index, :show]

  helper FoldersHelper, StepsHelper, TagsHelper

  #TODO extend filters
  before_filter :require_user
  before_filter :establish_project, :only => :index
  before_filter :establish_project_from_feature, :only => :show
  before_filter :establish_root_folder, :only => [:index, :show]
  before_filter :establish_all_folders, :only => [:index, :show, :refresh_folder_select]

  before_filter :establish_parents_via_params, :only => [:new, :create, :import]
  before_filter :establish_model_via_id_param, :only => [:show, :show_detail, :manage_tags, :modify_tags,
                                                         :edit, :update, :destroy]
  before_filter :verify_feature_file, :only => [:import]

  set_create_errors_area_dom_id(:folder_new_feature_errors)

  def index
    #Intentionally blank
  end

  def show_detail
    #Intentionally blank
  end

  def manage_tags
    @all_tags = current_project.tags.find(:all, :order => "name")
  end

  def modify_tags
    @feature.tags.line = params[:text]
  end

  def refresh_folder_select
    @form_name = params[:form_name]
  end

  def create
    super
    establish_new_description_line_add_anywhere_presenter
  end

  def import
    responds_to_parent do
      feature = FEATURE_IMPORTER.import(:file_path => write_uploaded_file(params[:feature_file]))
      feature.folder = @folder
      feature.save ? render_successful_import(feature) : render_import_errors(feature.errors)
    end
  end

  def export
    @feature = Shrink::Feature.find_by_id(params[:id])
    respond_to do |format|
      format.html
      format.feature do
        feature_file_path = FEATURE_EXPORTER.export(
                :feature => @feature, :destination_directory => session[:temp_directory])
        send_file(feature_file_path, :type => :feature)
      end
    end
  end

  private
  def establish_project
    store_current_project(params[:project_id])
  end

  def establish_project_from_feature
    store_current_project(@feature.folder.project.id)
  end

  def establish_root_folder
    @root_folder = current_project.root_folder
  end

  def establish_all_folders
    @folders = current_project.folders(true)
  end

  def verify_feature_file
    responds_to_parent { render_import_errors(["Feature to import required"]) } unless params[:feature_file]
  end

  def establish_new_description_line_add_anywhere_presenter
    @description_line_add_anywhere_presenter = AddAnywherePresenter.new(
            :model => Shrink::FeatureDescriptionLine.new(:feature => @feature), :controller => self,
            :clicked_container_dom_id => dom_id(@feature, :add_description_line_link_area))
  end

  def render_successful_import(feature)
    render(:update) { |page| hide_add_feature_form_and_show_feature(page, feature) }
  end

  def render_import_errors(errors)
    render_errors("import_feature_errors", errors)
  end

end
