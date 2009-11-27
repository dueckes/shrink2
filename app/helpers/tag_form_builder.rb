class TagFormBuilder < PlatterFormBuilder

  def cancel_add_button
    @template.button_to_remote("Cancel", :url => { :action => :cancel_create }, :id => "#{element_id_prefix}_cancel")
  end

  def element_id_prefix
    @object.new_record? ? "new_tag" : "tag_#{@object.id}"
  end

end
