class TagsController < RestfulAjaxApplicationController
   layout "main", :only => :index

   before_filter :establish_model_via_id_param, :only => [:show, :show_detail, :edit, :update, :destroy]

  def index
    @all = Platter::Tag.find(:all, :order => "name")
  end

  def show_detail
    #Intentionally blank
  end

end
