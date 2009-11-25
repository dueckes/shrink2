class CreateTableFeaturesTags < ActiveRecord::Migration

  def self.up
    create_table(:features_tags, :id => false) do |table|
      table.integer :feature_id, :null => false
      table.integer :tag_id, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:features_tags)
  end

end
