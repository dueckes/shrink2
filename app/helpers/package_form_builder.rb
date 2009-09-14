class PackageFormBuilder < PlatterFormBuilder

  def cancel_add_button
    @template.button_to_remote("Cancel", :url => { :action => :cancel_create, :parent_id => parent_id }, :id => "#{element_id_prefix}_cancel")
  end

  def element_id_prefix
    if @object.new_record?
      @template.nested_dom_id(:new_package, @object.parent)
    else
      "package_#{@object.id}"
    end
  end

  private
  def parent_id
    @object.parent ? @object.parent.id : nil
  end

end
