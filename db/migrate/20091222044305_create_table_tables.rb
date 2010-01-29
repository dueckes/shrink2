class CreateTableTables < ActiveRecord::Migration

  def self.up
    create_table(:tables) do |table|
      table.timestamps
    end
  end

  def self.down
    drop_table(:tables)
  end

end
