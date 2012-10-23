class CreateTableScenarioTags < ActiveRecord::Migration

  def self.up
    create_table(:scenario_tags) do |table|
      table.integer :scenario_id, :null => false
      table.integer :tag_id, :null => false
      table.timestamps
    end
  end

  def self.down
    drop_table(:scenario_tags)
  end

end
