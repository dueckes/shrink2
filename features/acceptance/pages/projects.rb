module Shrink
  module Acceptance
    module Pages
      class Projects < Shrink::Acceptance::Pages::Base

        PROJECT_LIST_SELECTOR = "ul#projects"

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
          @session.has_selector?(PROJECT_LIST_SELECTOR)
        end

        def add(name)
          @session.click_link("Add Project")
          wait_until_colorbox_popup_appears
          @session.fill_in("Name", :with => name)
          @session.click_button("Add")
          wait_until_colorbox_popup_disappears
        end

        def wait_until_project_link_is_shown!(name)
          Shrink::Acceptance::Wait.new(:message => "Timed out waiting for link of project named '#{name}' to be shown") do
            has_project_link?(name)
          end
        end

        def view(name)
          @session.within(PROJECT_LIST_SELECTOR) { @session.click_link(name) }
        end

        def wait_until_details_are_shown!(name)
          Shrink::Acceptance::Wait.new(:message => "Timed out waiting for details of project named '#{name}' to be shown") do
            is_showing_details_of?(name)
          end
        end

        private

        def has_project_link?(name)
          @session.within(PROJECT_LIST_SELECTOR) { @session.has_link?(name) }
        end

        def is_showing_details_of?(name)
          @session.within("#project_dashboard") { @session.has_content?(name) }
        end

      end
    end
  end
end
