# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def self.render_menu_extras(flag)
    @render_menu_extras = flag
  end

  def self.render_menu_extras?
    !!@render_menu_extras
  end

end
