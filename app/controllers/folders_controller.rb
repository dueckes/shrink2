class FoldersController < CrudApplicationController

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

end
