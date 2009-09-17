# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Similiar to div_for but produces an li tag
  def li_for(record, *args, &block)
    content_tag_for(:li, record, *args, &block)
  end

end
