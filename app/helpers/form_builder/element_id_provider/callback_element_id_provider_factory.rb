class CallbackElementIdProviderFactory

  def initialize(callback)
    @callback = callback
  end

  def create(form_builder)
    CallbackElementIdProvider.new(form_builder, @callback)
  end

end
