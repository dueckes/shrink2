class PackagesController < ApplicationController

  def index
    @packages = Platter::Package.roots
  end

  def new
  end

  def create
    @package = Platter::Package.new(params[:package])
    @package.save!
  end

  def show
    @package = Platter::Package.find(params[:id])
  end

  def shrink
    @package = Platter::Package.find(params[:id])
  end

end
