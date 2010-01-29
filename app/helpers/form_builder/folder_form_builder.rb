class FolderFormBuilder < ApplicationFormBuilder
  set_element_id_providers :add => :add_id_for

  def generic_element_id_prefix
    "folder"
  end

  def add_id_for(name)
    "#{@template.nested_dom_id(:new_folder, @object.parent)}_#{name}"
  end

end
