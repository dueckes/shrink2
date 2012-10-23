class ScenarioFormBuilder < ApplicationFormBuilder
  include AddAnywhereFormBuilder

  def generic_element_id_prefix
    "feature_#{@object.feature.id}_scenario"
  end

end
