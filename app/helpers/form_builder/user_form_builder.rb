class UserFormBuilder < ApplicationFormBuilder

  def generic_element_id_prefix
    "user"
  end

  def buttons_visible
    @options[:field_set] != :login
  end

end
