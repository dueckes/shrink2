module CrudApplicationControllerAddAnywhereSupport

  def self.included(controller)
    controller.before_filter :establish_clicked_item_dom_id, :only => [:new]
    controller.before_filter :normalize_position_param, :only => [:create]
    controller.before_filter :establish_add_anywhere_form_number, :only => [:new, :create]
    controller.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def new
      @model = nil
      establish_add_anywhere_presenter
    end

    def create_before_save
      establish_add_anywhere_presenter
    end
    
    private
    def normalize_position_param
      model_attributes = params[self.class.short_model_name]
      model_attributes[:position] =
              model_attributes[:position].to_i + self.class.model_class.first_position if model_attributes[:position]
    end

    def establish_clicked_item_dom_id
      @clicked_item_dom_id = params[:clicked_item_dom_id]
    end

    def establish_add_anywhere_form_number
      @add_anywhere_form_number = params[:add_anywhere_form_number].blank? ?
              next_add_anywhere_form_number : params[:add_anywhere_form_number]
    end

    def next_add_anywhere_form_number
      session[:add_anywhere_form_number] = session[:add_anywhere_form_number] ?
              session[:add_anywhere_form_number] + 1 : 1
    end

    def establish_add_anywhere_presenter
      @add_anywhere_presenter = AddAnywherePresenter.new(:new_model => @model, :parent_models => @parents,
                                                         :form_number => @add_anywhere_form_number,
                                                         :clicked_item_dom_id => @clicked_item_dom_id,
                                                         :short_model_name => self.class.short_model_name,
                                                         :template => @template)
    end

  end

end
