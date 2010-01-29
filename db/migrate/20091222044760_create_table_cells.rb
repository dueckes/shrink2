class CreateTableCells < ActiveRecord::Migration

  def self.up
    create_table(:cells) do |table|
      table.integer :row_id, :null => false
      table.integer :position, :null => false
      table.string :text, :limit => 256, :null => true
      table.timestamps
    end
  end

  def self.down
    drop_table(:cells)
  end

end
