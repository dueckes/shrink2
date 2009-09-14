class ScenariosController < ApplicationController

  def new
    @feature = Platter::Feature.find(params[:feature_id])
  end

  def cancel_create
    @feature = Platter::Feature.find(params[:feature_id])
  end

  def create
    @scenario = Platter::Scenario.new(params[:scenario])
    @scenario.feature = Platter::Feature.find(params[:feature_id])
    @scenario.save!
  end

  def show
    @scenario = Platter::Scenario.find(params[:id])
  end

  def edit
    @scenario = Platter::Scenario.find(params[:id])
  end

  def update
    if params[:commit] == "Update"
      @scenario = Platter::Scenario.find(params[:id])
      @scenario.update_attributes!(params[:scenario])
    end
    render(:action => :show)
  end

  def destroy
    Platter::Scenario.transaction do
      Platter::Scenario.destroy(params[:id])
    end
  end

end
