class PackagesController < ApplicationController
  layout "main", :only => :index
  helper :root_element

  def index
    @root_package = Platter::Package.root
  end

  def new
    establish_parent
  end

  def cancel_create
    establish_parent
  end

  def establish_model_for_create
    establish_parent
    set_model Platter::Package.new(params[:package].merge(:parent => @parent))
  end

  def collapse
    @package = Platter::Package.find(params[:id])
  end

  def destroy
    @package = Platter::Package.find(params[:id])
    @package.destroy
  end

  private
  def establish_parent
    @parent = params[:parent_id] ? Platter::Package.find(params[:parent_id]) : Platter::Package.root
  end

end
