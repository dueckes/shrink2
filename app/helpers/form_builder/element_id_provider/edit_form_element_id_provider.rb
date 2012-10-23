class EditFormElementIdProvider

  def initialize(form_builder)
    @form_builder = form_builder
  end

  def id_for(name)
    "#{@form_builder.generic_element_id_prefix}_#{@form_builder.object.id}_#{name}"
  end

end
