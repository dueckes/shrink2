module InlineEditHelper

  def inline_edit_link(text, options, html_options, *args)
    function = options[:function] || remote_function({ :method => :get }.merge(options))
    combined_html_options = { :title => "Click To Edit" }.merge(html_options)
    combined_html_options[:class] = combined_html_options[:class] ?
            combined_html_options[:class] += " editable_text_link" : "editable_text_link"
    link_to_function(text, function, combined_html_options, *args)
  end

  def edit_inline(page, model, model_name, field_name)
    element_id = "#{dom_id(model)}_#{field_name}"
    page.hide(element_id)
    page.replace_html(element_id, :partial => "#{model_name.to_s.pluralize}/form_edit", :locals => { model_name.to_sym => model })
    page << "new EditForm('##{element_id}').open()"
  end

  def update_inline(page, model, model_name, field_name)
    element_id = "#{dom_id(model)}_#{field_name}"
    page << "new EditForm('##{element_id}').close()"
    page.replace_html(element_id, :partial => "#{model_name.to_s.pluralize}/show_#{field_name}", :locals => { model_name.to_sym => model })
    page << "$('##{element_id}').fadeIn('fast')"
  end

end
