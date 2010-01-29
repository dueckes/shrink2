class CreateTableProjectUsers < ActiveRecord::Migration

  def self.up
    create_table(:project_users) do |table|
      table.integer :project_id, :null => false
      table.integer :user_id, :null => false
    end
  end

  def self.down
    drop_table(:project_users)
  end

end
