# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper InlineEditHelper, AddAnywhereHelper

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :establish_temp_file_directory
  before_filter :strip_string_parameters

  TMP_ROOT_DIRECTORY = "#{RAILS_ROOT}/tmp"

  class << self

    def render_extra_menu_items?
      @render_extra_menu_items ||= File.exists?("#{RAILS_ROOT}/app/views/#{self.controller_name}/_menu_items.html.erb")
    end

  end

  def establish_temp_file_directory
    session[:temp_directory] ||= File.join(TMP_ROOT_DIRECTORY, session[:session_id])
  end

  def strip_string_parameters
    params.each { |key, value| params[key] == value.strip if value.kind_of?(String) }
  end

  def write_uploaded_file(uploaded_file)
    destination_file_name = File.join(session[:temp_directory], uploaded_file.original_filename)
    File.open(destination_file_name, "w") { |file| file.write(uploaded_file.read) }
    destination_file_name
  end

end
