class FoldersController < ResourceApplicationController
  
  before_filter :establish_model_via_id_param, :only => [:show, :edit, :update, :destroy, :import, :export]
  before_filter :verify_zip_file, :only => [:import]

  def import
    responds_to_parent do
      errors = import_uploaded_file_and_return_errors
      errors.empty? ? render_successful_import : render_import_errors(errors)
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
    @root_folder = current_project.root_folder
    @feature = Shrink::Feature.find(params[:feature_id])
  end

  def move_feature
    @feature = Shrink::Feature.find(params[:source_id])
    @folder = Shrink::Folder.find(params[:destination_id])
    @feature.update_attributes(:folder => @folder)
  end

  def move_folder
    @source_folder = Shrink::Folder.find(params[:source_id])
    @destination_folder = Shrink::Folder.find(params[:destination_id])
    @source_folder.update_attributes(:parent => @destination_folder)
  end

  def establish_parents_via_params
    @parent = params[:parent_id] ? Shrink::Folder.find(params[:parent_id]) : current_project.root_folder
  end

  def establish_model_from_params
    establish_parents_via_params
    set_model Shrink::Folder.new(params[:folder].merge(:parent => @parent))
  end

  private
  def verify_zip_file
    responds_to_parent { render_import_errors(["Zip to import required"]) } unless params[:zip_file]
  end

  def import_uploaded_file_and_return_errors
    begin
      features = FOLDER_IMPORTER.import(:zip_file_path => write_uploaded_file(params[:zip_file]),
                                        :extract_root_directory => session[:temp_directory],
                                        :destination_folder => @folder)
      features.select { |feature| !feature.valid? }.collect(&:errors)
    rescue Shrink::ImportError => import_error
      [import_error.message]
    end
  end

  def render_successful_import
    render(:update) do |page|
      page << close_popup_form_js
      page << refresh_folder_js(@folder)
    end
  end

  def render_import_errors(errors)
    render_errors("folder_import_zip_errors", errors)
  end

end
