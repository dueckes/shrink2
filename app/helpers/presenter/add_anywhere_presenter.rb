class AddAnywherePresenter
  attr_reader :form_number, :clicked_item_dom_id

  def initialize(options)
    @template = options[:template]
    @parent_models = options[:parent_models]
    @short_model_name = options[:short_model_name]
    @form_number = options[:form_number]
    @new_model = options[:new_model]
    @clicked_item_dom_id = options[:clicked_item_dom_id]
  end

  def form_container_dom_id
    @template.dom_id(*(@parent_models + ["new_#{@short_model_name}_add_anywhere_form_#{@form_number}"]))
  end

  def show_form_js
    "new AddAnywhereForm('##{form_container_dom_id}').open()"
  end

  def show_model_js
    new_model_dom_id = @template.dom_id(@new_model)
    "new AddAnywhereForm('##{form_container_dom_id}', '##{new_model_dom_id}').showModel()"
  end

end
