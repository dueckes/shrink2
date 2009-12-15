require File.expand_path(File.dirname(__FILE__) + "/lib/action_view/helpers/scriptaculous_helper")
require File.expand_path(File.dirname(__FILE__) + "/lib/action_view/helpers/text_helper")

::ActionView::Helpers::ScriptaculousHelper.send(:include, ::Platter::ActionView::Helpers::ScriptaculousHelper)
::ActionView::Helpers::TextHelper.send(:include, ::Platter::ActionView::Helpers::TextHelper)
