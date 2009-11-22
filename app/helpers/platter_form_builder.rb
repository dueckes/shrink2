class PlatterFormBuilder < ActionView::Helpers::FormBuilder

  def commit_button
    submit_button_for(@object.new_record? ? :add : :update)
  end

  def cancel_button
    @object.new_record? ? cancel_add_button : submit_button_for(:cancel, :onclick => "this.form['cancel_edit'].value = true;")
  end

  def submit_button_for(verb, options={})
    submit(verb.to_s.capitalize, { :id => "#{element_id_prefix}_#{verb}" }.merge(options))
  end

  def text_field_for(field_as_symbol, options={})
    generate_text_field_for(field_as_symbol, options.merge({ :type => :standard }))
  end

  def auto_complete_text_field_for(field_as_symbol, options={})
    generate_text_field_for(field_as_symbol, options.merge({ :type => :auto_complete }))
  end

  private
  def self.object_name
    name.gsub(/FormBuilder/, "").lowercase.symbolize
  end

  def generate_text_field_for(field_as_symbol, options)
    %{
      #{self.send("#{options[:type]}_text_field", field_as_symbol, options)}
      #{@template.javascript_tag("$(\"#{element_id_prefix}_#{field_as_symbol}\").focus();")}
    }
  end

  def standard_text_field(field_as_symbol, options)
    text_field(field_as_symbol, text_field_tag_options(field_as_symbol, options))
  end

  def auto_complete_text_field(field_as_symbol, options)
    @template.text_field_with_auto_complete(
            self.object_name, field_as_symbol, text_field_tag_options(field_as_symbol, options))
  end

  def text_field_tag_options(field_as_symbol, options)
    { :size => 80, :maxlength => 255, :id => "#{element_id_prefix}_#{field_as_symbol}" }.merge(options)
  end

end
