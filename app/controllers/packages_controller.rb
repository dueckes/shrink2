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

  def create
    establish_parent
    @package = Platter::Package.new(params[:package].merge(:parent => @parent))
    @package.save!
  end

  def edit
    @package = Platter::Package.find(params[:id])
  end

  def update
    puts "params[:commit]: #{params[:commit]}"
    if params[:commit] == "Update"
      @package = Platter::Package.find(params[:id])
      @package.update_attributes!(params[:package])
    end
  end

  def show
    @package = Platter::Package.find(params[:id])
  end

  def shrink
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
