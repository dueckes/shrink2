class StepFormBuilder < ApplicationFormBuilder
  include AddAnywhereFormBuilder

  def generic_element_id_prefix
    "feature_#{@object.scenario.feature.id}_scenario_#{@object.scenario.id}_step"
  end

end
