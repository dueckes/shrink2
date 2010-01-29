module Shrink
  module AutoCompleteMacrosHelper

    # Patch Description:
    #   Specifying tag_options[:id] also effects id of div providing auto-complete options
    #
    def text_field_with_auto_complete(object, method, tag_options = {}, completion_options = {})
      text_field_id = tag_options[:id] || "#{object}_#{method}"
      div_id = "#{text_field_id}_auto_complete"
      combined_tag_options = tag_options.merge(:id => text_field_id)
      combined_completion_options = completion_options.merge(:update => div_id)

      (combined_completion_options[:skip_style] ? "" : auto_complete_stylesheet) +
      text_field(object, method, combined_tag_options) +
      content_tag("div", "", :id => div_id, :class => "auto_complete") +
      auto_complete_field(text_field_id, { :url => { :action => "auto_complete_for_#{object}_#{method}" } }.update(combined_completion_options))
    end

  end
end
