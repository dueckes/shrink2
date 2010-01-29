class StepTablePresenter < TablePresenter

  def initialize(step, controller)
    super(step.table, controller)
    @step = step
    @controller = controller
  end

  def show_url
    url_for(:controller => :steps, :action => :show, :id => @step.id)
  end

  def edit_url
    url_for(:controller => :steps, :action => :edit, :id => @step.id)
  end

  def save_url
    @step.new_record? ? create_url : update_url
  end

  private
  def create_url
    url_for(:controller => :steps, :action => :create_table, :scenario_id => @step.scenario.id)
  end

  def update_url
    url_for(:controller => :steps, :action => :update_table, :id => @step.id)
  end

end
