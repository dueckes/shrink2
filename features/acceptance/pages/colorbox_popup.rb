require File.expand_path('../../wait', __FILE__)

module Shrink
  module Acceptance
    module Pages
      module ColorboxPopup

        def wait_until_colorbox_popup_appears
          Shrink::Acceptance::Wait.new(:message => "Timed-out waiting for colorbox pop-up to appear").until do
            @session.has_selector?("#cboxLoadedContent", :visible => true)
          end
        end

        def wait_until_colorbox_popup_disappears
          Shrink::Acceptance::Wait.new(:message => "Timed-out waiting for colorbox pop-up to disappear").until do
            @session.has_no_selector?("#cboxLoadedContent")
          end
        end

      end
    end
  end
end
