class CreateTableFeautres < ActiveRecord::Migration

  def self.up
    create_table(:features) do |table|
      table.string :title, :limit => 256, :null => false
      table.string :summary, :limit => 4000, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:features)
  end

end
