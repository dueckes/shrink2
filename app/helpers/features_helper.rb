module FeaturesHelper

  def blind_up_tag_form_and_display_tag_list(page, feature)
    page.replace_html("#{dom_id(feature)}_tags_list_area", :partial => "features/show_tags", :locals => { :feature => feature })
    page.visual_effect(:blind_up, "#{dom_id(feature)}_tags_form_area", :duration => 0.5,
                       :afterFinish => "function() { $('#{dom_id(feature)}_tags_list_area').show(); $('#{dom_id(feature)}_tags_form_area').innerHTML = ''; }")
  end
  
end
