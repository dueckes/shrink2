module Shrink
  module PGconn

    def self.included(pg_conn)
      pg_conn.extend(ClassMethods)
    end

    module ClassMethods

      def quote_ident(name)
        %("#{name}")
      end

    end
  end
end
