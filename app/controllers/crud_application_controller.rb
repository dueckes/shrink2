class CrudApplicationController < ApplicationController
  before_filter :establish_parents_via_params, :only => [:new, :create]
  before_filter :establish_model_via_id_param, :only => [:show, :edit, :update, :destroy]

  class << self

    def model_class
      @model_class || Shrink::ModelReflections.class_for(self.controller_name.singularize)
    end

    def set_model_class(model_class)
      @model_class = model_class
    end

    def parent_associations
      self.model_class.parent_associations
    end

    def short_model_name
      self.model_class.short_name
    end

    def create_errors_area_dom_id
      @create_errors_area_dom_id
    end

    def set_create_errors_area_dom_id(dom_id)
      @create_errors_area_dom_id = dom_id
    end

    def model_persistence_methods
      @methods ||= { :create => :save, :update => :update_attributes, :destroy => :destroy }
    end

    def set_model_persistence_methods(methods)
      @methods = methods
    end

  end

  def new
    #Intentionally blank
  end

  def create
    establish_model_from_params
    create_before_save
    render_create_errors(@model.errors) unless @model.save
  end

  def create_before_save
    #Callback
  end

  def show
    #Intentionally blank
  end

  def edit
    #Intentionally blank
  end

  def update
    unless params[:cancel] == "true"
      unless @model.update_attributes(params[self.class.short_model_name])
        render_errors("#{dom_id(@model)}_errors", @model.errors)
      end
    end
  end

  def destroy
    @model.destroy
  end

  def establish_parents_via_params
    @parents = self.class.parent_associations.collect do |association|
      parent = association.model_class.find(params["#{association.name}_id"])
      instance_variable_set("@#{association.name}", parent)
      parent
    end
  end

  def establish_model_from_params
    set_model self.class.model_class.new(params[self.class.short_model_name])
    self.class.parent_associations.each do |association|
      @model.send("#{association.name}=", instance_variable_get("@#{association.name}"))
    end
  end

  def establish_model_via_id_param
    set_model find_model(params)
  end

  def create_errors_area_dom_id(model)
    self.class.create_errors_area_dom_id || default_create_errors_area_dom_id(model)
  end

  def set_model(model)
    @model = model
    instance_variable_set("@#{self.class.short_model_name}", model)
  end

  def render_create_errors(errors)
    render_errors(create_errors_area_dom_id(@model), errors)
  end

  def render_errors(element_id, *errors)
    error_messages = errors.flatten
    if errors.flatten.all? { |error| error.respond_to?(:full_messages) }
      error_messages = errors.flatten.collect { |error| error.full_messages }.flatten
    end
    render(:update) do |page|
      page.replace_html(element_id, :partial => "common/show_errors", :locals => { :error_messages => error_messages })
      page.show(element_id)
    end
  end

  private
  def find_model(params)
    self.class.model_class.find(params[:id])
  end

  def default_create_errors_area_dom_id(model)
    prefix = model.class.parent_associations.collect { |association| dom_id(model.send(association.name)) }.join("_")
    "#{prefix}_new_#{model.class.short_name}_errors"
  end

end
