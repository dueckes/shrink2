module FeaturesHelper

  def blind_up_tag_form_and_display_tag_list(page, feature)
    page.replace_html("#{dom_id(feature)}_tags_list", :partial => "features/show_tags", :locals => { :feature => feature })
    page << "new TagForm('##{dom_id(feature)}_tags_area').close();"
  end

  def hide_top_menu_and_show_feature(page, feature, action)
    page << "new TopMenuItem('#{action}_feature').hide();"
    page.replace_html("content_inner_area", :partial => "features/show_all", :locals => { :features => [feature], :minimized => false })
    page.show("#content_inner_area")
    page << refresh_folder_js(feature.folder)
  end
  
end
