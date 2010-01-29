class CreateTableRows < ActiveRecord::Migration

  def self.up
    create_table(:rows) do |table|
      table.integer :table_id, :null => false
      table.integer :position, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:rows)
  end

end
