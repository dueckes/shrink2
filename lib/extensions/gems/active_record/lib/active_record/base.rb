module Shrink
  module ActiveRecord
    module Base

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do

          class << self
            #alias_method_chain :establish_connection, :postgres_adapter_load_corrections
          end

          before_save { |model| model.register_as_transaction_participant }
          after_save { |model| model.before_commit(:save) }

          before_destroy { |model| model.register_as_transaction_participant }
          after_destroy { |model| model.before_commit(:destroy) }

        end
        base.send(:include, InstanceMethods)
      end

      module ClassMethods

        def short_name
          @short_name || self.contextless_name.downcase.to_sym
        end

        def set_short_name(short_name)
          @short_name = short_name.to_sym
        end

        def parent_associations
          self.reflect_on_all_associations.collect do |association|
            association.macro == :belongs_to ? ::Shrink::ParentAssociation.new(
                    :model_class => eval(association.options[:class_name]), :name => association.name) : nil
          end.compact
        end

        def establish_connection_with_postgres_adapter_load_corrections(spec=nil)
          establish_connection_without_postgres_adapter_load_corrections(spec)
          customize_postgresql_adapter(spec.symbolize_keys) if spec.respond_to?(:symbolize_keys)
        end

        private
        def customize_postgresql_adapter(spec)
          ::PGconn.send(:include, ::Shrink::PGconn) if spec[:adapter] == 'postgresql'
        end

      end

      module InstanceMethods

        attr_accessor :executing_before_commit_when_first_transaction_participant
        alias_method :executing_before_commit_when_first_transaction_participant?,
                     :executing_before_commit_when_first_transaction_participant

        def parents
          self.class.parent_associations.collect { |association| self.send(association.name) }
        end

        def register_as_transaction_participant
          connection.started_persisting(self)
        end

        def first_transaction_participant?
          connection.first_participant_in_transaction?(self)
        end

        def before_commit(callback_method)
          if first_transaction_participant? && !executing_before_commit_when_first_transaction_participant?
            self.executing_before_commit_when_first_transaction_participant = true
            self.send("before_#{callback_method}_commit_when_first_transaction_participant")
            self.executing_before_commit_when_first_transaction_participant = false
          end
        end

        def before_save_commit_when_first_transaction_participant
          # Intentionally blank callback
        end

        def before_destroy_commit_when_first_transaction_participant
          # Intentionally blank callback
        end

      end

    end
  end
end
