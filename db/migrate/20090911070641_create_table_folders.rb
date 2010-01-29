class CreateTableFolders < ActiveRecord::Migration

  def self.up
    create_table(:folders) do |table|
      table.integer :parent_id
      table.integer :project_id, :null => false
      table.string :name, :limit => 256, :null => false
    end
  end

  def self.down
    drop_table(:folders)
  end

end
