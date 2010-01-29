class CreateTableFeautres < ActiveRecord::Migration

  def self.up
    create_table(:features) do |table|
      table.integer :project_id, :null => false
      table.integer :folder_id, :null => false
      table.string :title, :limit => 256, :null => false
      table.text :summary, :null => true
      table.timestamps
    end
  end

  def self.down
    drop_table(:features)
  end

end
