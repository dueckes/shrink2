class DescriptionLinesController < ResourceApplicationController
  include ResourceApplicationControllerAddAnywhereSupport
  set_model_class Shrink::FeatureDescriptionLine

  layout nil

  #TODO Append to existing filters
  before_filter :strip_string_parameters, :except => [:auto_complete_text]
  before_filter :establish_parents_via_params, :only => [:new, :create, :auto_complete_text]

  def auto_complete_text
    @suggestions = Shrink::TextSuggester::FeatureDescriptionLineSuggester.suggestions_for(
            params[:q], params[:position], @feature)
  end

end
