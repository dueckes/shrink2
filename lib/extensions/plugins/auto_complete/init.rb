require File.expand_path(File.dirname(__FILE__) + "/lib/auto_complete_macros_helper")

ActionController::Base.helper(::Platter::AutoCompleteMacrosHelper)
