module Shrink
  module Acceptance
    module Pages
      class Home < Shrink::Acceptance::Pages::Base

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
end
