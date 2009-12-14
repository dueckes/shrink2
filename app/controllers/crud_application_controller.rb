class CrudApplicationController < ApplicationController
  before_filter :establish_parents_via_params, :only => [:new, :create]
  before_filter :establish_model_via_id_param, :only => [:show, :edit, :update, :destroy]

  class << self

    def model_class
      @model_class || Platter.const_get(self.controller_name.singularize.capitalize)
    end

    def set_model_class(model_class)
      @model_class = model_class
    end

    def short_model_name
      @short_model_name || self.model_class.contextless_name.downcase
    end

    def set_short_model_name(short_model_name)
      @short_model_name = short_model_name
    end

    def fully_distinguished_model_name
      self.model_class.model_name.singular
    end

  end

  def new
    #Intentionally blank
  end

  def create
    establish_model_for_create
    create_before_save
    if !@model.save
      id_prefix = new_id_prefix(@model)
      short_model_name = self.class.short_model_name
      render_errors("#{id_prefix}_new_#{short_model_name}_errors", @model.errors)
    end
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
    unless params[:cancel_edit] == "true"
      if !@model.update_attributes(params[self.class.short_model_name])
        render_errors("#{dom_id(@model)}_errors", @model.errors)
      end
    end
  end

  def destroy
    @model.destroy
  end

  def establish_parents_via_params
    @parents = self.class.model_class.belongs_to_associations.collect do |association|
      parent = association.model_class.find(params["#{association.name}_id"])
      instance_variable_set("@#{association.name}", parent)
      parent
    end
  end

  def establish_model_for_create
    set_model self.class.model_class.new(params[self.class.short_model_name])
    self.class.model_class.belongs_to_associations.each do |association|
      @model.send("#{association.name}=", instance_variable_get("@#{association.name}"))
    end
  end

  def establish_model_via_id_param
    set_model find_model(params)
  end

  def new_id_prefix(model)
    association_names = self.class.model_class.belongs_to_associations.collect { |association| association.name }
    association_names.collect { |name| dom_id(model.send(name)) }.join("_")
  end

  def set_model(model)
    @model = model
    instance_variable_set("@#{self.class.short_model_name}", model)
  end

  def next_form_number
    session[:form_number] = session[:form_number] ? session[:form_number] + 1 : 1
  end

  def render_errors(element_id, errors)
    error_messages = errors.respond_to?(:full_messages) ? errors.full_messages : errors
    render(:update) do |page|
      page.replace_html(element_id, :partial => "common/show_errors", :locals => { :error_messages => error_messages })
      page.show(element_id)
    end
  end

  private
  def find_model(params)
    self.class.model_class.find(params[:id])
  end

end
