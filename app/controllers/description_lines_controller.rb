class DescriptionLinesController < CrudApplicationController
  include CrudApplicationControllerAddAnywhereSupport
  set_model_class Platter::FeatureDescriptionLine
  set_short_model_name :description_line
end
