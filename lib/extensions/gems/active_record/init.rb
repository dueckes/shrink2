require File.expand_path("../pg_conn", __FILE__)
require File.expand_path("../lib/active_record/base", __FILE__)
require File.expand_path("../lib/active_record/option_manipulation", __FILE__)
require File.expand_path("../lib/active_record/connection_adapters/abstract_adapter", __FILE__)

::ActiveRecord::Base.send(:include, ::Shrink::ActiveRecord::Base)
::ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, ::Shrink::ActiveRecord::ConnectionAdapters::AbstractAdapter)
