class ProjectFormBuilder < ApplicationFormBuilder

  def generic_element_id_prefix
    "project"
  end

  def buttons_visible
    @object.new_record?
  end

end
