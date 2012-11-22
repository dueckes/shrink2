class AddAnywherePresenter < ApplicationPresenter
  attr_reader :clicked_container_dom_id, :container_dom_id

  def initialize(options)
    super(options[:model], options[:controller])
    @clicked_container_dom_id = options[:clicked_container_dom_id]
    @container_dom_id = options[:container_dom_id]
  end

  def container_dom_id
    @container_dom_id ||= view_context.dom_id(
            *(model.parents + ["new_#{model.class.short_name}_#{controller.next_number(model_name.to_sym)}"]))
  end

  def show_form_js
    "new AddAnywhereForm('##{container_dom_id}').open();"
  end

  def show_model_and_clear_form_js
    "#{create_form_with_model_js}.showModelAndClearForm();"
  end

  def show_model_and_remove_form_js
    "#{create_form_with_model_js}.showModelAndRemoveForm();"
  end

  private
  def create_form_with_model_js
    "new AddAnywhereForm('##{container_dom_id}', '##{view_context.dom_id(model)}')"
  end

end
