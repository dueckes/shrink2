module Shrink
  module Cucumber
    module Formatter

      module TextFormatter

        def self.included(obj)
          obj.class_eval do
            alias_attribute :to_cucumber_file_format, :text
          end
        end

      end

    end
  end
end
