class CreateTablePackages < ActiveRecord::Migration

  def self.up
    create_table(:packages) do |table|
      table.integer :parent_id
      table.string :name, :size => 256, :null => false
    end
  end

  def self.down
    drop_table(:packages)
  end

end
