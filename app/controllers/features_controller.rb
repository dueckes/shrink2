class FeaturesController < ApplicationController

  def index
    @package = Platter::Package.find(params[:package_id])
  end

  def import_gesture
    @package = Platter::Package.find(params[:package_id])
  end
               
  def import
    responds_to_parent do
      @feature = Platter::Cucumber::FeatureImporter.import_file(write_feature_file(params[:feature_file]))
      @feature.package = Platter::Package.find(params[:package_id])
      @feature.save!
      render(:update) do |page|
        page.insert_html(:before, "#{dom_id(@feature.package)}_new_feature", :partial => "features/show_link", :locals => { :feature => @feature })
        page.hide("#{dom_id(@feature.package)}_new_feature")
        page.replace_html("#{dom_id(@feature.package)}_new_feature", "")
        page.show("#{dom_id(@feature.package)}_new_feature_controls")
      end
    end
  end

  def destroy
    @feature = Platter::Feature.find(params[:id])
    @feature.destroy
  end

  private
  def write_feature_file(uploaded_feature_file)
    destination_file_name = "#{Platter::Feature::UPLOAD_DIRECTORY}/#{uploaded_feature_file.original_filename}"
    File.open(destination_file_name, "w") { |file| file.write(uploaded_feature_file.read) }
    destination_file_name
  end

end
