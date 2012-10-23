class FeatureDescriptionLineFormBuilder < ApplicationFormBuilder
  include AddAnywhereFormBuilder

  def generic_element_id_prefix
    "feature_#{@object.feature.id}_description_line"
  end

end
