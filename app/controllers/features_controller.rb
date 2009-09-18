class FeaturesController < ApplicationController
  layout "main", :only => :index
  render_menu_extras :true

  def index
    @package = Platter::Package.find(params[:package_id])
  end

  def new
    @package = Platter::Package.find(params[:package_id])
  end

  def cancel_create
  end

  def create
    @feature = Platter::Feature.new(params[:feature])
    @feature.package = Platter::Package.find(params[:package_id])
    @feature.save!
  end

  def shrink
    @feature = Platter::Feature.find(params[:id])
  end

  def show
    @feature = Platter::Feature.find(params[:id])
  end

  def edit
    @feature = Platter::Feature.find(params[:id])
  end

  def update
    if params[:commit] == "Update"
      @feature = Platter::Feature.find(params[:id])
      @feature.update_attributes!(params[:feature])
    end
    render(:action => :shrink)
  end

  def destroy
    Platter::Feature.transaction do
      Platter::Feature.destroy(params[:id])
    end
  end

  def import
    responds_to_parent do
      @feature = Platter::Cucumber::FeatureImporter.import_file(write_feature_file(params[:feature_file]))
      @feature.package = Platter::Package.find(params[:package_id])
      @feature.save!
      render(:update) do |page|
        page.insert_html(:bottom, :features, :partial => "features/show_shrunk_with_li", :locals => { :feature => @feature })
        page.visual_effect(:toggle_blind, "importform")
        page["feature_file"].clear
      end
    end
  end

  private
  def write_feature_file(uploaded_feature_file)
    destination_file_name = "#{Platter::Feature::UPLOAD_DIRECTORY}/#{uploaded_feature_file.original_filename}"
    File.open(destination_file_name, "w") { |file| file.write(uploaded_feature_file.read) }
    destination_file_name
  end

end
