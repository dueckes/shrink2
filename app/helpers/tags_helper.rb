module TagsHelper

  def update_feature_tag_lines(page, tag)
    tag.features.each do |feature|
      page.replace_html("#{dom_id(feature)}_tags_list", :partial => "features/show_tags", :locals => { :feature => feature })
    end
  end

end
