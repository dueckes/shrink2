require File.expand_path(File.dirname(__FILE__) + "/lib/active_record/acts/list")

::ActiveRecord::Base.send(:include, ::Shrink::ActiveRecord::Acts::List)
