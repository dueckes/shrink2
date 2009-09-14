class PackagesController < ApplicationController
  layout "main", :only => :index

  def index
    @packages = Platter::Package.roots
  end

  def new
    puts "PackagesController.new: Entry"
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
