require File.expand_path(File.dirname(__FILE__) + "/pg_conn")

PGconn.send(:extend, ::Platter::PGconn::ClassMethods)
