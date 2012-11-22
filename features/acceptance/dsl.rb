module Shrink
  module Acceptance
    module DSL

      def find_page(page_name)
        page_class = Shrink::Acceptance::Pages::Base.page_class_with_name(page_name)
        page_class.new(Capybara.current_session)
      end

      def find_role(role_name)
        Shrink::Acceptance::Role.from_name(role_name)
      end

    end
  end
end
