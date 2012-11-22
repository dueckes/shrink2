module Shrink
  module Acceptance
    module Pages
      class Projects < Shrink::Acceptance::Pages::Base

        def self.name
          "projects"
        end

        def initialize(session)
          super(session)
        end

        def url
          "/projects"
        end

        def shown?
          @session.has_selector?("#projects")
        end

      end
    end
  end
end
