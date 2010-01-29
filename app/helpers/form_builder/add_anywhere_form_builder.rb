module AddAnywhereFormBuilder

  def self.included(form_builder_class)
    form_builder_class.set_element_id_providers :add => AddAnywhereFormElementIdProvider
  end

end
