class EditFormPresenter < ApplicationPresenter

  def initialize(field_set_name, model, controller)
    super(model, controller)
    @field_set_name = field_set_name
  end

  def form_id
    @field_set_name ? "#{model_name}_edit_#{@field_set_name}_form" : template.dom_id(@model, :edit_form)
  end

  def field_set_partial
    partial_path = "#{model_name.to_s.pluralize}/form_common"
    partial_path = "#{partial_path}_#{@field_set_name}" if @field_set_name
    partial_path
  end

end
