require File.expand_path("../lib/active_record/acts/list", __FILE__)

::ActiveRecord::Base.send(:include, ::Shrink::ActiveRecord::Acts::List)
