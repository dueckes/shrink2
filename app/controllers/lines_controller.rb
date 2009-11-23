class LinesController < RestfulAjaxApplicationController
  set_model_class Platter::FeatureLine
  set_model_name_in_view :line
end
