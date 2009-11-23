module Platter
  module ActiveRecord
    module Base

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          class << self
            alias_method_chain :establish_connection, :postgres_adapter_load_corrections
          end
        end
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

        def establish_connection_with_postgres_adapter_load_corrections(spec=nil)
          establish_connection_without_postgres_adapter_load_corrections(spec)
          customize_postgresql_adapter(spec.symbolize_keys) if spec.respond_to?(:symbolize_keys)
        end

        private
        def customize_postgresql_adapter(spec)
          ::PGconn.send(:include, ::Platter::PGconn) if spec[:adapter] == 'postgresql'
        end

      end

    end
  end
end
