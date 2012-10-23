module FeaturesHelper

  def hide_add_feature_form_and_show_feature(page, feature)
    page << close_popup_form_js
    page.replace_html("features_container", :partial => "features/show_all", :locals => { :features => [feature], :minimized => false })
    page << refresh_folder_js(feature.folder)
  end

end
