module StepsHelper

  def table_presenter_for(step)
    StepTablePresenter.new(step, controller)
  end

end
