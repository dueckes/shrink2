module Platter
  module Cucumber
    module Formatter

      module TagFormatter

        def self.included(obj)
          obj.send(:include, InstanceMethods)
        end

        module InstanceMethods

          def to_cucumber_file_format
            "@#{name.gsub(/\s/, "_")}"
          end

        end

      end

    end
  end
end
