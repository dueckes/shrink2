class StepFormBuilder < PlatterFormBuilder

  def cancel_add_button
    @template.button_to_remote("Cancel", :url => { :action => :cancel_create, :scenario_id => @object.scenario.id }, :id => "#{element_id_prefix}_cancel")
  end

  def element_id_prefix
    @object.new_record? ? "new_feature_#{@object.scenario.feature.id}_scenario_#{@object.scenario.id}_step" : "feature_#{@object.scenario.feature.id}_scenario_#{@object.scenario.id}_step_#{@object.id}"
  end

end
