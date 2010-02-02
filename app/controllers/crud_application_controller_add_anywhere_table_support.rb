module CrudApplicationControllerAddAnywhereTableSupport

  def self.included(controller)
    controller.before_filter :translate_number_of_rows_to_number_of_persistable_rows
    controller.before_filter :translate_number_of_columns_to_number_of_persistable_columns
    controller.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def new_table
      establish_model_from_params
      establish_empty_table_in_model
      establish_add_anywhere_presenter
      render :action => :new
    end

    def create_table
      establish_model_from_params
      save_model_with_table
      establish_add_anywhere_presenter
      render :action => :create
    end

    def update_table
      unless params[:cancel] == "true"
        establish_model_via_id_param
        save_model_with_table
      end
      render :action => :update
    end

    private
    def translate_number_of_rows_to_number_of_persistable_rows
      params[:number_of_rows] = params[:number_of_rows].to_i - 2 if params[:number_of_rows]
    end

    def translate_number_of_columns_to_number_of_persistable_columns
      params[:number_of_columns] = params[:number_of_columns].to_i - 1 if params[:number_of_columns]
    end

    def establish_empty_table_in_model
      @model.table = Shrink::Table.new_empty
    end

    def save_model_with_table
      @model.save_with_table(
              {:rows => params[:number_of_rows], :columns => params[:number_of_columns] }, params[:cells][:text])
    end

  end

end
