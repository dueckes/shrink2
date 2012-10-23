class AddFormElementIdProvider

  def initialize(form_builder)
    @form_builder = form_builder
  end

  def id_for(name)
    "new_#{@form_builder.generic_element_id_prefix}_#{name}"
  end

end
