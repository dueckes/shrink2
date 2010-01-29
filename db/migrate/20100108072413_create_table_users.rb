class CreateTableUsers < ActiveRecord::Migration

  def self.up
    create_table(:users) do |table|
      table.integer :role_id, :null => false
      table.string :login, :limit => 128, :null => false
      table.string :encrypted_password, :limit => 128, :null => false
      table.string :password_salt, :limit => 128, :null => false
      table.string :persistence_token, :limit => 128, :null => false
      table.datetime :last_request_at
    end
  end

  def self.down
    drop_table(:users)
  end

end
