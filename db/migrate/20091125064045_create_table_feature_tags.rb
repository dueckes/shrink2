class CreateTableFeatureTags < ActiveRecord::Migration

  def self.up
    create_table(:feature_tags) do |table|
      table.integer :feature_id, :null => false
      table.integer :tag_id, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:feature_tags)
  end

end
