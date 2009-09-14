class StepsController < ApplicationController

  def new
    @scenario = Platter::Scenario.find(params[:scenario_id])
  end

  def auto_complete_for_step_text
    user_text = params[:step][:text] ? params[:step][:text].downcase : ""
    @steps = Platter::Step.find(:all, :conditions => "LOWER(text) LIKE '#{user_text}%'",
                                      :order => "text ASC", :limit => 10)
  end

  def cancel_create
    @scenario = Platter::Scenario.find(params[:scenario_id])
  end

  def create
    @step = Platter::Step.new(params[:step])
    @step.scenario = Platter::Scenario.find(params[:scenario_id])
    @step.save!
  end

  def destroy
    Platter::Step.transaction do
      Platter::Step.destroy(params[:id])
    end
  end

  def edit
    @step = Platter::Step.find(params[:id])
  end

  def update
    if params[:commit] == "Update"
      @step = Platter::Step.find(params[:id])
      @step.update_attributes!(params[:step])
    end
    render(:action => :show)
  end
  
end
