class StubModelFixture

  def self.create_model(model_class, stubs)
    model = model_class.new
    stubs.each { |method, value| model.stub!(method => value) }
    model
  end

end
