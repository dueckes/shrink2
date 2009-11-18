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
      if !@scenario.update_attributes(params[:scenario])
        render(:update) do |page|
          page.replace_html("#{dom_id(@scenario)}_errors", :partial => "common/show_errors", :locals => { :errors => @scenario.errors })
        end
      end
    end
  end

  def destroy
    @scenario = Platter::Scenario.find(params[:id])
    @scenario.destroy
  end

end
