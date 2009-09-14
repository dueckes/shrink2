class CreateTableFeatureLines < ActiveRecord::Migration

  def self.up
    create_table(:feature_lines) do |table|
      table.integer :feature_id, :null => false
      table.integer :position, :null => false
      table.string :text, :size => 256, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:feature_lines)
  end

end
