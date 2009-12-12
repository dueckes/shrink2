class FoldersController < CrudApplicationController
  #TODO extend filters
  before_filter :establish_model_via_id_param, :only => [:show, :toggle, :edit, :update, :destroy]

  def toggle
    #Intentionally blank
  end

  def establish_parents_via_params
    @parent = params[:parent_id] ? Platter::Folder.find(params[:parent_id]) : Platter::Folder.root
  end

  def establish_model_for_create
    establish_parents_via_params
    set_model Platter::Folder.new(params[:folder].merge(:parent => @parent))
  end

end
