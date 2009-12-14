class FoldersController < CrudApplicationController

  def move
    @feature = Platter::Feature.find(params[:source_id])
    @folder = Platter::Folder.find(params[:destination_id])
    @feature.update_attributes(:folder => @folder)
  end

  def establish_parents_via_params
    @parent = params[:parent_id] ? Platter::Folder.find(params[:parent_id]) : Platter::Folder.root
  end

  def establish_model_for_create
    establish_parents_via_params
    set_model Platter::Folder.new(params[:folder].merge(:parent => @parent))
  end

end
