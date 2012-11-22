require File.expand_path("../lib/declarative_authorization/action_pack/action_view/base", __FILE__)
require File.expand_path("../lib/declarative_authorization/active_record/base", __FILE__)

::ActionView::Base.send(:include, ::Shrink::DeclarativeAuthorization::ActionPack::ActionView::Base)
::ActiveRecord::Base.send(:include, ::Shrink::DeclarativeAuthorization::ActiveRecord::Base)
