class ScenariosController < CrudApplicationController
  include CrudApplicationControllerAddAnywhereSupport

  def create
    super
    @step_add_anywhere_presenter = AddAnywherePresenter.new(
            :template => @template, :parent_models => [@scenario], :short_model_name => :step,
            :form_number => @add_anywhere_form_number, :clicked_item_dom_id => dom_id(@scenario, :add_step_link_area))
  end

end
