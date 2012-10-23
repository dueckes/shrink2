class CallbackElementIdProvider

  def initialize(form_builder, callback_method)
    @form_builder = form_builder
    @callback_method = callback_method
  end

  def id_for(name)
    @form_builder.send(@callback_method, name)
  end

end
