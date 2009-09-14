class LinesController < ApplicationController

  def list
  end

  def new
    @feature = Platter::Feature.find(params[:feature_id])
  end

  def cancel_create
    @feature = Platter::Feature.find(params[:feature_id])
  end

  def create
    @line = Platter::FeatureLine.new(params[:line])
    @line.feature = Platter::Feature.find(params[:feature_id])
    @line.save!
  end

  def show
    @line = Platter::FeatureLine.find(params[:id])
  end

  def edit
    @line = Platter::FeatureLine.find(params[:id])
  end

  def update
    if params[:commit] == "Update"
      @line = Platter::FeatureLine.find(params[:id])
      @line.update_attributes!(params[:line])
    end
    render(:action => :show)
  end

  def destroy
    Platter::FeatureLine.transaction do
      Platter::FeatureLine.destroy(params[:id])
    end
  end

end
