module Shrink
  module ActiveRecord
    module ConnectionAdapters

      module AbstractAdapter

        def self.included(adapter)
          adapter.send(:include, InstanceMethods)
          adapter.class_eval { alias_method_chain :transaction, :outer_model_tracking }
        end

        module InstanceMethods

          def first_participant_in_transaction?(model)
            first_participant_in_transaction && first_participant_in_transaction.object_id == model.object_id
          end

          def started_persisting(model)
            @outer_models[@outer_models.size - 1] = model if @outer_models.last.nil?
          end

          def transaction_with_outer_model_tracking(*args, &block)
            @outer_models ||= []
            @outer_models.push(nil)
            begin
              result = transaction_without_outer_model_tracking(*args, &block)
            ensure
              @outer_models.pop
            end
            result
          end

          private
          def first_participant_in_transaction
            @outer_models.first
          end

        end

      end

    end
  end
end
