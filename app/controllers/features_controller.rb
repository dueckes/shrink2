class FeaturesController < CrudApplicationController
  layout "features", :only => [:index, :show]

  #TODO extend filters
  before_filter :establish_parents_via_params, :only => [:new, :create, :import]
  before_filter :establish_model_via_id_param, :only => [:show, :show_detail, :manage_tags, :modify_tags,
                                                         :edit, :update, :destroy]
  before_filter :establish_root_folder, :only => [:index, :show]
  before_filter :verify_search_text, :only => [:search]
  before_filter :verify_feature_file, :only => [:import]

  def index
    @count = Platter::Feature.count
  end

  def search
    #TODO Pagination
    @search_text = params[:text]
    @features = Platter::Feature.find(:all, :conditions => ["lower(summary) like ?", "%#{@search_text.downcase}%"])
    @tags = Platter::Tag.find(:all, :conditions => ["lower(name) like ?", "%#{@search_text.downcase}%"])
  end

  def show_detail
    #Intentionally blank
  end

  def manage_tags
    @all_tags = Platter::Tag.find(:all, :order => "name")
  end

  def modify_tags
    @feature.tag_line = params[:text]
  end

  def add_gesture
    @folders = Platter::Folder.find(:all)
  end

  def import_gesture
    @folders = Platter::Folder.find(:all)
  end

  def import
    responds_to_parent do
      feature = Platter::Cucumber::FeatureImporter.import_file(write_feature_file(params[:feature_file]))
      feature.folder = @folder
      feature.save ? render_successful_import(feature) : render_import_errors(feature.errors)
    end
  end

  def new_id_prefix(model=nil)
    "folder"
  end

  private
  def establish_root_folder
    @root_folder = Platter::Folder.root
  end

  def verify_search_text
    render_errors("search_errors", ["Search text required"]) if params[:text].blank?
  end
  
  def verify_feature_file
    responds_to_parent { render_import_errors(["Feature to import required"]) } unless params[:feature_file]
  end

  def write_feature_file(uploaded_feature_file)
    destination_file_name = "#{Platter::Feature::UPLOAD_DIRECTORY}/#{uploaded_feature_file.original_filename}"
    File.open(destination_file_name, "w") { |file| file.write(uploaded_feature_file.read) }
    destination_file_name
  end

  def render_successful_import(feature)
    render(:update) { |page| hide_top_menu_and_show_feature(page, feature, "import") }
  end

  def render_import_errors(errors)
    render_errors("import_feature_errors", errors)
  end

end
