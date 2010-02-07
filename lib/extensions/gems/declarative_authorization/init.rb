require File.expand_path(File.dirname(__FILE__) + "/lib/declarative_authorization/action_view/base")
require File.expand_path(File.dirname(__FILE__) + "/lib/declarative_authorization/active_record/base")

::ActionView::Base.send(:include, ::Shrink::DeclarativeAuthorization::ActionView::Base)
::ActiveRecord::Base.send(:include, ::Shrink::DeclarativeAuthorization::ActiveRecord::Base)
