class CreateTableSteps < ActiveRecord::Migration

  def self.up
    create_table(:steps) do |table|
      table.integer :scenario_id, :null => false
      table.integer :position, :null => false
      table.string :text, :limit => 256, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:steps)
  end

end
