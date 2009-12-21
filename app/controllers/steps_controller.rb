class StepsController < CrudApplicationController
  include CrudApplicationControllerAddAnywhereSupport

  before_filter :strip_string_parameters, :except => [:auto_complete_for_step_text]
  before_filter :establish_parents_via_params, :only => [:new, :create, :auto_complete_for_step_text]

  def auto_complete_for_step_text
    @step_text_suggestions =
            Platter::StepTextSuggester::Suggester.suggestions_for(params[:q], params[:position].to_i, @scenario)
  end

  def reorder
    scenario = Platter::Scenario.find(params['add_step_link_area_platter_scenario'][0])
    scenario.order_steps(params['platter_step'].collect(&:to_i))
    render :nothing => true
  end

end
