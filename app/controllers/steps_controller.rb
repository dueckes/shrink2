class StepsController < ApplicationController

  def new
    @scenario = Platter::Scenario.find(params[:scenario_id])
  end

  def auto_complete_for_step_text
    user_text = params[:step][:text] ? params[:step][:text].downcase : ""
    # TODO Script injection protection, find() approach?
    @steps = Platter::Step.find_by_sql(
            %{SELECT DISTINCT(text) from #{Platter::Step.table_name} 
              WHERE LOWER(text) LIKE '#{user_text}%'
              ORDER BY text ASC
              LIMIT 10})
  end

  def cancel_create
    @scenario = Platter::Scenario.find(params[:scenario_id])
  end

  def create
    @step = Platter::Step.new(params[:step])
    @step.scenario = Platter::Scenario.find(params[:scenario_id])
    @step.save!
  end

  def edit
    @step = Platter::Step.find(params[:id])
  end

  def update
    if params[:commit] == "Update"
      @step = Platter::Step.find(params[:id])
      if !@step.update_attributes(params[:step])
        render(:update) do |page|
          page.replace_html("#{dom_id(@step)}_errors", :partial => "common/show_errors", :locals => { :errors => @step.errors })
        end
      end
    end
  end
  
  def destroy
    @step = Platter::Step.find(params[:id])
    @step.destroy
  end

end
