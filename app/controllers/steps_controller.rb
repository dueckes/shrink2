class StepsController < RestfulAjaxApplicationController

  def auto_complete_for_step_text
    user_text = params[:step][:text] ? params[:step][:text].downcase : ""
    # TODO Script injection protection, find() approach?
    @steps = Platter::Step.find_by_sql(
            %{SELECT DISTINCT(text) from #{Platter::Step.table_name} 
              WHERE LOWER(text) LIKE '#{user_text}%'
              ORDER BY text ASC
              LIMIT 10})
  end

  def reorder
    scenario = Platter::Scenario.find(params['add_step_platter_scenario'][0])
    scenario.order_steps(params['platter_step'].collect(&:to_i))
    render :nothing => true
  end

end
