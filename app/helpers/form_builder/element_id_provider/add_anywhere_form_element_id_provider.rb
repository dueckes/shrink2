class AddAnywhereFormElementIdProvider

  def initialize(form_builder)
    @form_builder = form_builder
  end

  def id_for(name)
    "add_anywhere_form_#{@form_builder.options[:add_anywhere_presenter].form_number}_#{@form_builder.generic_element_id_prefix}_#{name}"
  end                                  

end
