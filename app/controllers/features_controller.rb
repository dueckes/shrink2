class FeaturesController < RestfulAjaxApplicationController
  layout "main", :only => :show

  #TODO extend filters
  before_filter :establish_parents_via_params, :only => [:new, :cancel_create, :import_gesture]
  before_filter :establish_model_via_id_param, :only => [:show, :show_detail, :show_url, :close_url, :new_tags, :cancel_create_tags, :create_tags, :edit, :update, :destroy]

  def show
    @root_package = Platter::Package.root
  end

  def show_detail
    #Intentionally blank
  end

  def show_url
    #Intentionally blank
  end
  
  def close_url
    #Intentionally blank
  end

  def new_tags
    #Intentionally blank
  end

  def cancel_create_tags
    #Intentionally blank
  end

  def create_tags
    if params[:text].empty?
      render_errors("#{dom_id(@feature)}_add_tags_errors", ["Tags must be provided"])
    else
      tag_names = params[:text].split(",").collect(&:strip).uniq
      feature_tag_names = @feature.tags.collect(&:name)
      unassociated_tag_names = tag_names.find_all { |tag_name| !feature_tag_names.include?(tag_name) }
      unassociated_tag_names.each { |tag_name| @feature.tags << Platter::Tag.find_or_create!(:name => tag_name) }
    end
  end

  def import_gesture
    #Intentionally blank
  end

  def import
    responds_to_parent do
      feature = Platter::Cucumber::FeatureImporter.import_file(write_feature_file(params[:feature_file]))
      feature.package = Platter::Package.find(params[:package_id])
      feature.save ? render_successful_import(feature) : render_import_error(feature)
    end
  end

  private
  def write_feature_file(uploaded_feature_file)
    destination_file_name = "#{Platter::Feature::UPLOAD_DIRECTORY}/#{uploaded_feature_file.original_filename}"
    File.open(destination_file_name, "w") { |file| file.write(uploaded_feature_file.read) }
    destination_file_name
  end

  def render_successful_import(feature)
    render(:update) do |page|
      page.insert_html(:before, "#{dom_id(feature.package)}_new_feature", :partial => "features/show_link", :locals => { :feature => feature })
      page.hide("#{dom_id(feature.package)}_new_feature")
      page.replace_html("#{dom_id(feature.package)}_new_feature", "")
      page.show("#{dom_id(feature.package)}_new_feature_controls")
    end
  end

  def render_import_error(feature)
    render(:update) do |page|
      page.replace_html("#{dom_id(feature.package)}_import_feature_errors", :partial => "common/show_errors", :locals => { :errors => feature.errors })
      page.show("#{dom_id(feature.package)}_import_feature_errors")
    end
  end

end
