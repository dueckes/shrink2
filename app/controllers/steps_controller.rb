class StepsController < ApplicationController

  def auto_complete_for_step_text
    user_text = params[:step][:text] ? params[:step][:text].downcase : ""
    # TODO Script injection protection, find() approach?
    @steps = Platter::Step.find_by_sql(
            %{SELECT DISTINCT(text) from #{Platter::Step.table_name} 
              WHERE LOWER(text) LIKE '#{user_text}%'
              ORDER BY text ASC
              LIMIT 10})
  end

  def destroy
    @step = Platter::Step.find(params[:id])
    @step.destroy
  end

end
