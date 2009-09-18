module Platter
  module ActiveRecord
    module Acts
      module List

        def self.included(base)
          base.extend(ClassMethods)
          base.send(:include, InstanceMethods)
        end

        # Patch description
        # 1. When removing from list, the element's position is no longer set to nil
        #    This allows a not-null constraint to be added to the position column
        # 2. When adding to the list, a position is not auto-generated if a position is already provided.
        #
        module ClassMethods

          def acts_as_list(options = {})
            configuration = { :column => "position", :scope => "1 = 1" }
            configuration.update(options) if options.is_a?(Hash)

            configuration[:scope] = "#{configuration[:scope]}_id".intern if configuration[:scope].is_a?(Symbol) && configuration[:scope].to_s !~ /_id$/

            if configuration[:scope].is_a?(Symbol)
              scope_condition_method = %(
                def scope_condition
                  if #{configuration[:scope].to_s}.nil?
                    "#{configuration[:scope].to_s} IS NULL"
                  else
                    "#{configuration[:scope].to_s} = \#{#{configuration[:scope].to_s}}"
                  end
                end
              )
            else
              scope_condition_method = "def scope_condition() \"#{configuration[:scope]}\" end"
            end

            class_eval <<-EOV
              include ::ActiveRecord::Acts::List::InstanceMethods

              def acts_as_list_class
                ::#{self.name}
              end

              def position_column
                '#{configuration[:column]}'
              end

              #{scope_condition_method}

              before_destroy :remove_from_list_without_position_change
              before_create :establish_position_if_required
            EOV
          end

        end

        module InstanceMethods

          def remove_from_list_without_position_change
            decrement_positions_on_lower_items if in_list?
          end

          private
          def establish_position_if_required
            self[position_column] = bottom_position_in_list.to_i + 1 unless self[position_column]
          end

        end

      end
    end
  end
end
