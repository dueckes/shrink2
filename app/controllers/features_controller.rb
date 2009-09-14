class FeaturesController < ApplicationController
  layout "main", :only => :index

  def index
    @package = Platter::Package.find(params[:package_id])
  end

  def new
  end

  def cancel_create
  end

  def create
    @feature = Platter::Feature.new(params[:feature])
    @feature.package = Platter::Package.find(params[:package_id])
    @feature.save!
  end

  def shrink
    @feature = Platter::Feature.find(params[:id])
  end

  def show
    @feature = Platter::Feature.find(params[:id])
  end

  def edit
    @feature = Platter::Feature.find(params[:id])
  end

  def update
    puts "params[:commit]: #{params[:commit]}"
    if params[:commit] == "Update"
      @feature = Platter::Feature.find(params[:id])
      @feature.update_attributes!(params[:feature])
    end
    render(:action => :shrink)
  end

  def destroy
    Platter::Feature.transaction do
      Platter::Feature.destroy(params[:id])
    end
  end

end