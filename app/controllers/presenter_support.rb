module PresenterSupport

  def template
    self.instance_variable_get("@template")
  end

end
