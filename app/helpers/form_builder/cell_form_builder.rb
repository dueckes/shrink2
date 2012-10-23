class CellFormBuilder < ApplicationFormBuilder
  include AddAnywhereFormBuilder

  def generic_element_id_prefix
    "table_#{@object.table.id}_row_#{@object.row.id}_step"
  end

end
