# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  class << self

    def render_extra_menu_items?
      @render_extra_menu_items ||= File.exists?("#{RAILS_ROOT}/app/views/#{self.controller_name}/_menu_items.html.erb")
    end

  end

end
