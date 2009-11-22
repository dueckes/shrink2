module Platter
  module ActiveRecord
    module Base

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        class BelongsToAssociation
          attr_reader :name, :model_class

          def initialize(options)
            @name = options[:name]
            @model_class = options[:model_class]
          end
        end

        def belongs_to_associations
          self.reflect_on_all_associations.collect do |association|
            association.macro == :belongs_to ? BelongsToAssociation.new(
                    :name => association.name, :model_class => eval(association.options[:class_name])) : nil
          end.compact
        end

      end

    end
  end
end
