module Shrink

  module BelongsToTable

    def self.included(model_class)
      model_class.belongs_to :table, :class_name => "Shrink::Table"
      model_class.extend(ClassMethods)
      model_class.send(:include, InstanceMethods)
    end

    module ClassMethods

      #TODO Modify belongs_to to include/exclude parent associations
      def parent_associations
        super.select { |association| association.name != :table }
      end

    end

    module InstanceMethods

      def save_with_table(dimensions, cells_text)
        ::ActiveRecord::Base.transaction do
          self.table ? update_associated_table(dimensions, cells_text) : create_associated_table(dimensions, cells_text)
          self.save!
        end
      end

      #TODO :dependent => :destroy not honoured for belongs_to relationship
      def destroy
        super
        self.table.destroy if self.table
      end

      private
      def create_associated_table(dimensions, cell_texts)
        self.table = Shrink::Table.create_with_dimensions_and_texts!(dimensions, cell_texts)
      end

      def update_associated_table(dimensions, cell_texts)
        self.table.update_with_dimensions_and_texts!(dimensions, cell_texts)
      end

    end

  end

end
