class AddAnywhereFormElementIdProvider

  def initialize(form_builder)
    @form_builder = form_builder
  end

  def id_for(name)
    "#{@form_builder.options[:add_anywhere_presenter].container_dom_id}_#{name}"
  end                                  

end
