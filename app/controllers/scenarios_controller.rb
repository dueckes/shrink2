class ScenariosController < ResourceApplicationController
  include ResourceApplicationControllerAddAnywhereSupport

  def create
    super
    @step_add_anywhere_presenter = AddAnywherePresenter.new(
            :model => Shrink::Step.new(:scenario => @scenario), :controller => self,
            :clicked_container_dom_id => dom_id(@scenario, :add_step_link_area))
  end

end
