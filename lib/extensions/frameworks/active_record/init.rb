require File.expand_path(File.dirname(__FILE__) + "/pg_conn")
require File.expand_path(File.dirname(__FILE__) + "/lib/active_record/base")

ActiveRecord::Base.send(:include, ::Platter::ActiveRecord::Base)
