class FeatureFormBuilder < PlatterFormBuilder

  def cancel_add_button
    @template.button_to_remote("Cancel", :url => { :action => :cancel_create, :package_id => @object.package.id }, :id => "#{element_id_prefix}_cancel")
  end

  def element_id_prefix
    @object.new_record? ? "new_feature" : "feature_#{@object.id}"
  end

end
