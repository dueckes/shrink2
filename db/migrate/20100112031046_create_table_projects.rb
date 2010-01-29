class CreateTableProjects < ActiveRecord::Migration

  def self.up
    create_table(:projects) do |table|
      table.string :name, :limit => 256, :null => false
    end
  end

  def self.down
    drop_table(:projects)
  end

end
