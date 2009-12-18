class FoldersController < CrudApplicationController
  before_filter :establish_model_via_id_param, :only => [:show, :edit, :update, :destroy,
                                                         :import_gesture, :import, :export]
  before_filter :verify_zip_file, :only => [:import]

  def import_gesture
    # Intentionally blank
  end

  def import
    responds_to_parent do
      features = FOLDER_IMPORTER.import(:zip_file_path => write_uploaded_file(params[:zip_file]), 
                                        :extract_root_directory => session[:temp_directory],
                                        :destination_folder => @folder)
      invalid_features = features.select { |feature| !feature.valid? }
      invalid_features.empty? ? render_successful_import(@folder) :
              render_import_errors(@folder, invalid_features.collect(&:errors))
    end
  end

  def export
    respond_to do |format|
      format.zip do
        zip_file_path = FOLDER_EXPORTER.export(:folder => @folder, :zip_root_directory => session[:temp_directory])
        send_file(zip_file_path, :type => :zip)
      end
    end
  end

  def show_feature
    @root_folder = Platter::Folder.root
    @feature = Platter::Feature.find(params[:feature_id])
  end

  def move_feature
    @feature = Platter::Feature.find(params[:source_id])
    @folder = Platter::Folder.find(params[:destination_id])
    @feature.update_attributes(:folder => @folder)
  end

  def move_folder
    @source_folder = Platter::Folder.find(params[:source_id])
    @destination_folder = Platter::Folder.find(params[:destination_id])
    @source_folder.update_attributes(:parent => @destination_folder)
  end

  def establish_parents_via_params
    @parent = params[:parent_id] ? Platter::Folder.find(params[:parent_id]) : Platter::Folder.root
  end

  def establish_model_for_create
    establish_parents_via_params
    set_model Platter::Folder.new(params[:folder].merge(:parent => @parent))
  end

  private
  def verify_zip_file
    responds_to_parent { render_import_errors(@folder, ["Zip to import required"]) } unless params[:zip_file]
  end

  def render_successful_import(folder)
    render(:update) { |page| page << refresh_folder_js(folder) }
  end

  def render_import_errors(folder, errors)
    render_errors("#{dom_id(folder)}_import_zip_errors", errors)
  end

end
