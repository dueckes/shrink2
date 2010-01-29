require File.expand_path(File.dirname(__FILE__) + "/pg_conn")
require File.expand_path(File.dirname(__FILE__) + "/lib/active_record/base")
require File.expand_path(File.dirname(__FILE__) + "/lib/active_record/option_manipulation")
require File.expand_path(File.dirname(__FILE__) + "/lib/active_record/connection_adapters/abstract_adapter")

::ActiveRecord::Base.send(:include, ::Shrink::ActiveRecord::Base)
::ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, ::Shrink::ActiveRecord::ConnectionAdapters::AbstractAdapter)
