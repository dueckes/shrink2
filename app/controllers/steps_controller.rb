class StepsController < CrudApplicationController
  include CrudApplicationControllerAddAnywhereSupport

  def auto_complete_for_step_text
    # TODO Script injection protection, find() approach?
    @steps = Platter::Step.find_by_sql(
            %{SELECT DISTINCT(text) from #{self.class.model_class.table_name} 
              WHERE LOWER(text) LIKE '#{params[:q]}%'
              ORDER BY text ASC
              LIMIT 10})
  end

  def reorder
    scenario = Platter::Scenario.find(params['add_step_link_area_platter_scenario'][0])
    scenario.order_steps(params['platter_step'].collect(&:to_i))
    render :nothing => true
  end

end
