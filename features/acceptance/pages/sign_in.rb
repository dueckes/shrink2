module Shrink
  module Acceptance
    module Pages
      class SignIn < Shrink::Acceptance::Pages::Base

        def self.name
          "sign-in"
        end

        def initialize(session)
          super(session)
        end

        def url
          "/sign_in"
        end

        def shown?
          @session.has_content?('Sign In') && @session.has_field?('Username') && @session.has_field?('Password')
        end

        def sign_in(role)
          @session.fill_in('Username', :with => role.username)
          @session.fill_in('Password', :with => role.password)
          @session.click_button('Sign In')
        end

      end
    end
  end
end
