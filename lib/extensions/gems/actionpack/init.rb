require File.expand_path(File.dirname(__FILE__) + "/lib/action_view/helpers/scriptaculous_helper")

::ActionView::Helpers::ScriptaculousHelper.send(:include, ::Platter::ActionView::Helpers::ScriptaculousHelper)
