class AddColumnFolderIdToFeatures < ActiveRecord::Migration

  def self.up
    add_column(:features, :folder_id, :integer, :null => false)
  end

  def self.down
    remove_column(:features, :folder_id)
  end

end
