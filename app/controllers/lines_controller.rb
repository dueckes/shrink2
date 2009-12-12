class LinesController < CrudApplicationController
  include CrudApplicationControllerAddAnywhereSupport
  set_model_class Platter::FeatureLine
  set_short_model_name :line
end
