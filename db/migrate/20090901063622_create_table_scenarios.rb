class CreateTableScenarios < ActiveRecord::Migration

  def self.up
    create_table(:scenarios) do |table|
      table.integer :feature_id, :null => false
      table.integer :position, :null => false
      table.string :title, :size => 256, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:scenarios)
  end

end
