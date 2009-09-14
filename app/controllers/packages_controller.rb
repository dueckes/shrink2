class PackagesController < ApplicationController
  layout "main", :only => :index

  def index
    @packages = Platter::Package.roots
  end

  def new
    @parent = params[:parent_id] ? Platter::Package.find(params[:parent_id]) : nil
  end

  def cancel_create
    @parent = params[:parent_id] ? Platter::Package.find(params[:parent_id]) : nil
  end

  def create
    @parent = params[:parent_id] ? Platter::Package.find(params[:parent_id]) : nil
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
      render(:partial => "packages/show", :locals => { :package => @package})
    end
  end

  def show
    @package = Platter::Package.find(params[:id])
  end

  def shrink
    @package = Platter::Package.find(params[:id])
  end

  def destroy
    Platter::Package.destroy(params[:id])
  end

end
