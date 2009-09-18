module Platter
  module PGconn

    module ClassMethods

      def quote_ident(name)
        %("#{name}")
      end

    end

  end
end
