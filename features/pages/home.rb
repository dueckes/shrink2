module Shrink
  module Pages
    class Home < Shrink::Pages::Base

      def self.name
        "home"
      end

      def initialize(session)
        super(session)
      end

      def url
        "/"
      end

      def shown?
        @session.has_content?("Shrink - confide and benefit")
      end

    end
  end
end
