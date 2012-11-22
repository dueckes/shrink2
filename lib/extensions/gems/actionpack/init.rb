require File.expand_path("../lib/action_view/helpers/text_helper", __FILE__)

::ActionView::Helpers::TextHelper.send(:include, ::Shrink::ActionView::Helpers::TextHelper)
