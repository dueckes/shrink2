class PlatterFormBuilder < ActionView::Helpers::FormBuilder

  def submit_button
    verb = @object.new_record? ? "add" : "update"
    submit(verb.capitalize, :id => "#{element_id_prefix}_#{verb}")
  end

  def cancel_button
    @object.new_record? ? cancel_add_button : submit("Cancel", :id => "#{element_id_prefix}_cancel")
  end

  def text_field_for(element_symbol)
    %{
      #{text_field(element_symbol, :size => 256, :maxlength => 256, :id => "#{element_id_prefix}_#{element_symbol}")}
      #{@template.javascript_tag("$(\"#{element_id_prefix}_#{element_symbol}\").focus();")}
    }
  end

end
