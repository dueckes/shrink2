require File.expand_path('../colorbox_popup', __FILE__)
require File.expand_path('../../wait', __FILE__)

module Shrink
  module Acceptance
    module Pages
      class Base
        include Shrink::Acceptance::Pages::ColorboxPopup

        def self.inherited(subclass)
          @page_classes ||= []
          @page_classes << subclass
        end

        def self.page_class_with_name(name)
          @page_classes.find { |page_class| page_class.name == name }.tap do |page_class|
            raise "Page with name '#{name}' not found" unless page_class
          end
        end

        def initialize(session)
          @session = session
        end

        def visit
          @session.visit(url)
        end

        def shown_without_error?
          shown? && @session.has_no_content?("error")
        end

        def wait_until_shown!
          Shrink::Acceptance::Wait.new(:message => "Timed-out waiting for #{self.class.name} page to be shown").until do
            shown?
          end
        end

        def wait_until_shown_without_error!
          Shrink::Acceptance::Wait.new(:message => "Timed-out waiting for #{self.class.name} page to be shown without error").until do
            shown_without_error?
          end
        end

      end
    end
  end
end
