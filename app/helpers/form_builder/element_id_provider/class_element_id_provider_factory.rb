class ClassElementIdProviderFactory

  def initialize(element_id_provider_class)
    @element_id_provider_class = element_id_provider_class
  end

  def create(form_builder)
    @element_id_provider_class.new(form_builder)
  end

end
