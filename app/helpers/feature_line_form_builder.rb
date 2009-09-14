class FeatureLineFormBuilder < PlatterFormBuilder

  def cancel_add_button
    @template.button_to_remote("Cancel", :url => { :action => :cancel_create, :feature_id => @object.feature.id }, :id => "#{element_id_prefix}_cancel")
  end

  def element_id_prefix
    @object.new_record? ? "new_feature_#{@object.feature.id}_line" : "feature_#{@object.feature.id}_line_#{@object.id}"
  end

end
