# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SessionNumberGenerator
  include PresenterSupport
  include CurrentUserSupport
  include CurrentProjectSupport
  include AuthorizationSupport

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper InlineEditHelper, AddAnywhereHelper, CellsHelper, TablesHelper, IconsHelper

  before_filter :initialize_session
  before_filter :establish_temp_file_directory
  before_filter :strip_string_parameters
  before_filter :translate_position_to_integer

  SESSION_TMP_ROOT_DIRECTORY = Rails.root.join('tmp', 'sessions')

  def initialize_session
    session[:session_initializer] = ""
  end

  def establish_temp_file_directory
    unless session[:temp_directory]
      session[:temp_directory] = SESSION_TMP_ROOT_DIRECTORY.join(request.session_options[:id].to_s)
      FileUtils.mkdir_p(session[:temp_directory])
    end
  end

  def strip_string_parameters
    params.each { |key, value| params[key] == value.strip if value.kind_of?(String) }
  end

  def translate_position_to_integer
    params[:position] = params[:position].to_i if params[:position]
  end

  def write_uploaded_file(uploaded_file)
    destination_file_name = File.join(session[:temp_directory], uploaded_file.original_filename)
    File.open(destination_file_name, "w") { |file| file.write(uploaded_file.read) }
    destination_file_name
  end

end
