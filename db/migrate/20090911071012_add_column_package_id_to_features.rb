class AddColumnPackageIdToFeatures < ActiveRecord::Migration

  def self.up
    add_column(:features, :package_id, :integer, :null => false)
  end

  def self.down
    remove_column(:features, :package_id)
  end

end
