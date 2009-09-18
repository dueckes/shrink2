# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  class << self

    def layout_with_menu_support(template_name, conditions={}, auto=false)
      resolved_conditions = {}.merge(conditions)
      @render_extra_menu_items = resolved_conditions.delete(:extra_menu_items)
      layout_without_menu_support(template_name, resolved_conditions, auto)
    end
    alias_method_chain :layout, :menu_support

    def render_extra_menu_items?
      !!@render_extra_menu_items
    end

  end

end
