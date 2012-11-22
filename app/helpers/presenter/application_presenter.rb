class ApplicationPresenter
  attr_reader :model, :controller

  def initialize(model_or_dom_id, controller)
    establish_model_or_dom_id(model_or_dom_id)
    @controller = controller
  end

  def dom_id
    @dom_id ||= @model.new_record? ? "new_#{model_name}_#{next_number(model_name.to_sym)}" : view_context.dom_id(@model)
  end

  def model_name
    @model.class.short_name
  end

  def method_missing(name, *args, &block)
    @controller.send(name.to_sym, *args, &block)
  end

  private
  def establish_model_or_dom_id(model_or_dom_id)
    if model_or_dom_id.is_a?(::ActiveRecord::Base)
      @model = model_or_dom_id
      instance_variable_set("@#{model_name}", @model)
    else
      @dom_id = model_or_dom_id
    end
  end

end
