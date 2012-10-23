module TagsHelper

  def update_tag_lines(page, tag)
    tag.models.each do |model|
      page.replace_html("#{dom_id(model)}_tags_list", :partial => "tags/show_tags", :locals => { :model => model })
    end
  end

  def show_tag_form(page, model, all_tags)
    page.replace_html("#{dom_id(model)}_tags_form_area", :partial => "tags/form_tags", :locals => { :model => model, :all_tags => all_tags })
    page << "new TagForm('##{dom_id(model)}_tags_area').open();"
  end

  def hide_tag_form_and_display_tag_list(page, model)
    page.replace_html("#{dom_id(model)}_tags_list", :partial => "tags/show_tags", :locals => { :model => model })
    page << "new TagForm('##{dom_id(model)}_tags_area').close();"
  end

end
