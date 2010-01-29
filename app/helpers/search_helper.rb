module SearchHelper

  def search_preview(feature, search_text)
    preview_text = feature.search_result_preview(search_text)
    highlight(textilize(preview_text), search_text)
  end

  def feature_results_pagination_label(features)
    features.size > SearchController::RESULTS_PER_PAGE ? "<span>page:</span>" : ""
  end

end
