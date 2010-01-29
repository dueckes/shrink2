class CreateTableTags < ActiveRecord::Migration

  def self.up
    create_table(:tags) do |table|
      table.integer :project_id, :null => false
      table.string :name, :limit => 256, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:tags)
  end

end
