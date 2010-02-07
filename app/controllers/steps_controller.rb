class StepsController < ResourceApplicationController
  include ResourceApplicationControllerAddAnywhereSupport
  include ResourceApplicationControllerAddAnywhereTableSupport

  layout nil

  #TODO Append to existing filters
  before_filter :strip_string_parameters, :except => [:auto_complete_text]

  before_filter :establish_parents_via_params, :only => [:new, :new_table, :create, :create_table, :auto_complete_text]
  before_filter :establish_model_via_id_param, :only => [:show, :edit, :update, :update_table, :destroy]

  before_filter :normalize_position_param, :only => [:create, :create_table]

  def auto_complete_text
    @suggestions = Shrink::TextSuggester::StepSuggester.suggestions_for(params[:q], params[:position], @scenario)
  end

  def reorder
    scenario = Shrink::Scenario.find(params['add_step_link_area_shrink_scenario'][0])
    scenario.order_steps(params['shrink_step'].collect(&:to_i))
    scenario.feature.update_summary!
    render :nothing => true
  end

end
