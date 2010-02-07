module ResourceApplicationControllerAddAnywhereSupport

  def self.included(controller)
    controller.before_filter :normalize_position_param, :only => [:create]
    controller.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def new
      establish_model_from_params
      establish_add_anywhere_presenter
    end

    def create_before_save
      establish_add_anywhere_presenter
    end
    
    private
    def normalize_position_param
      normalize_position_in(params, params[self.class.short_model_name])
    end

    def normalize_position_in(*hashes)
      hashes.each do |hash|
        hash[:position] = hash[:position].to_i + self.class.model_class.first_position if hash && hash[:position]
      end
    end

    def establish_add_anywhere_presenter
      @add_anywhere_presenter = AddAnywherePresenter.new(:model => @model, :controller => self, 
                                                         :container_dom_id => params[:container_dom_id],
                                                         :clicked_container_dom_id => params[:clicked_container_dom_id])
    end

  end

end
