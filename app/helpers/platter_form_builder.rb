class PlatterFormBuilder < ActionView::Helpers::FormBuilder
  include AutoComplete

  def commit_button
    submit_button_for(@object.new_record? ? :add : :update)
  end

  def cancel_button
    @object.new_record? ? cancel_add_button : submit_button_for(:cancel)
  end

  def submit_button_for(verb)
    submit(verb.to_s.capitalize, :id => "#{element_id_prefix}_#{verb}")
  end

  def text_field_for(element_symbol)
    %{
      #{text_field(element_symbol, :size => 256, :maxlength => 256, :id => "#{element_id_prefix}_#{element_symbol}")}
      #{@template.javascript_tag("$(\"#{element_id_prefix}_#{element_symbol}\").focus();")}
    }
  end

  def auto_complete_text_field_for(field, options = {})
    @template.text_field_with_auto_complete(self.object_name, field, options)
  end

  private
  def self.object_name
    name.gsub(/FormBuilder/, "").lowercase.symbolize
  end

end
