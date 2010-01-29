class CreateTableRoles < ActiveRecord::Migration

  def self.up
    create_table(:roles) do |table|
      table.string :name, :limit => 256, :null => false
      table.string :description, :limit => 256, :null => false
    end
  end

  def self.down
    drop_table(:roles)
  end

end
