module StandardRestfulAjaxExtension

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods

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

  module InstanceMethods

    def new
      establish_belongs_to_association_instance_variables
    end

    def cancel_create
      establish_belongs_to_association_instance_variables
    end

    def create
      establish_model_for_create
      if !@model.save
        id_prefix = new_id_prefix(@model)
        model_name_in_view = self.class.model_name_in_view
        render(:update) do |page|
          page.replace_html("#{id_prefix}_new_#{model_name_in_view}_errors",
                            :partial => "common/show_errors", :locals => { :errors => @model.errors })
        end
      end
    end

    def show
      set_model find_model(params)
    end

    def edit
      set_model find_model(params)
    end

    def update
      set_model find_model(params)
      unless params[:cancel_edit] == "true"
        if !@model.update_attributes(params[self.class.model_name_in_view])
          render(:update) do |page|
            page.replace_html("#{dom_id(@model)}_errors",
                              :partial => "common/show_errors", :locals => { :errors => @model.errors })
          end
        end
      end
    end

    def establish_model_for_create
      set_model self.class.model_class.new(params[self.class.model_name_in_view])
      self.class.model_class.belongs_to_associations.each do |association|
        @model.send("#{association.name}=", association.model_class.find(params["#{association.name}_id"]))
      end
    end

    def new_id_prefix(model)
      association_names = self.class.model_class.belongs_to_associations.collect { |association| association.name }
      association_names.collect { |name| dom_id(model.send(name)) }.join("_")
    end

    def set_model(model)
      @model = model
      instance_variable_set("@#{self.class.model_name_in_view}", model)
    end

    private
    def establish_belongs_to_association_instance_variables
      self.class.model_class.belongs_to_associations.each do |association|
        instance_variable_set("@#{association.name}", association.model_class.find(params["#{association.name}_id"]))
      end
    end

    def find_model(params)
      self.class.model_class.find(params[:id])
    end

  end

end
