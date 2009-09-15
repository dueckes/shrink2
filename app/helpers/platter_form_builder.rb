class PlatterFormBuilder < ActionView::Helpers::FormBuilder

  def commit_button
    submit_button_for(@object.new_record? ? :add : :update)
  end

  def cancel_button
    @object.new_record? ? cancel_add_button : submit_button_for(:cancel)
  end

  def submit_button_for(verb)
    submit(verb.to_s.capitalize, :id => "#{element_id_prefix}_#{verb}")
  end

  def text_field_for(field_as_symbol)
    generate_text_field_for(field_as_symbol, :standard)
  end

  def auto_complete_text_field_for(field_as_symbol)
    generate_text_field_for(field_as_symbol, :auto_complete)
  end

  private
  def self.object_name
    name.gsub(/FormBuilder/, "").lowercase.symbolize
  end

  def generate_text_field_for(field_as_symbol, type)
    %{
      #{self.send("#{type}_text_field", field_as_symbol)}
      #{@template.javascript_tag("$(\"#{element_id_prefix}_#{field_as_symbol}\").focus();")}
    }
  end

  def standard_text_field(field_as_symbol)
    text_field(field_as_symbol, text_field_tag_options(field_as_symbol))
  end

  def auto_complete_text_field(field_as_symbol)
    @template.text_field_with_auto_complete(self.object_name, field_as_symbol, text_field_tag_options(field_as_symbol))
  end

  def text_field_tag_options(field_as_symbol)
    { :size => 256, :maxlength => 256, :id => "#{element_id_prefix}_#{field_as_symbol}" }
  end

end
