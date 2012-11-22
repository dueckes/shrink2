module Shrink
  module Pages
    module DSL

      def find_page(page_name)
        page_class = Shrink::Pages::Base.page_class_with_name(page_name)
        page_class.new(Capybara.current_session)
      end

    end
  end
end

World(Shrink::Pages::DSL)
