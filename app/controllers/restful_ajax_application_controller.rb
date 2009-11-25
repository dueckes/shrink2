class RestfulAjaxApplicationController < ApplicationController
  before_filter :establish_parents_via_params, :only => [:new, :cancel_create]
  before_filter :establish_model_via_id_param, :only => [:show, :edit, :update, :destroy]

  class << self

    def model_class
      @model_class || Platter.const_get(self.controller_name.singularize.capitalize)
    end

    def set_model_class(model_class)
      @model_class = model_class
    end

    def model_name_in_view
      @model_name_in_view || self.model_class.contextless_name.downcase
    end

    def set_model_name_in_view(model_name_in_view)
      @model_name_in_view = model_name_in_view
    end

  end

  def new
    #Intentionally blank
  end

  def cancel_create
    #Intentionally blank
  end

  def create
    establish_model_for_create
    if !@model.save
      id_prefix = new_id_prefix(@model)
      model_name_in_view = self.class.model_name_in_view
      render_errors("#{id_prefix}_new_#{model_name_in_view}_errors", @model.errors)
    end
  end

  def show
    #Intentionally blank
  end

  def edit
    #Intentionally blank
  end

  def update
    unless params[:cancel_edit] == "true"
      if !@model.update_attributes(params[self.class.model_name_in_view])
        render_errors("#{dom_id(@model)}_errors", @model.errors)
      end
    end
  end

  def destroy
    @model.destroy
  end

  def establish_parents_via_params
    self.class.model_class.belongs_to_associations.each do |association|
      instance_variable_set("@#{association.name}", association.model_class.find(params["#{association.name}_id"]))
    end
  end

  def establish_model_for_create
    set_model self.class.model_class.new(params[self.class.model_name_in_view])
    self.class.model_class.belongs_to_associations.each do |association|
      @model.send("#{association.name}=", association.model_class.find(params["#{association.name}_id"]))
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
    instance_variable_set("@#{self.class.model_name_in_view}", model)
  end

  def render_errors(element_id, errors)
    error_messages = errors.respond_to?(:full_messages) ? errors.full_messages : errors
    render(:update) do |page|
      page.replace_html(element_id, :partial => "common/show_errors", :locals => { :error_messages => error_messages })
    end
  end

  private
  def find_model(params)
    self.class.model_class.find(params[:id])
  end

end
