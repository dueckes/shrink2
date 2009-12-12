# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091125064045) do

  create_table "feature_description_lines", :force => true do |t|
    t.integer  "feature_id",                :null => false
    t.integer  "position",                  :null => false
    t.string   "text",       :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feature_tags", :force => true do |t|
    t.integer  "feature_id", :null => false
    t.integer  "tag_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.string   "title",      :limit => 256,  :null => false
    t.string   "summary",    :limit => 4000, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "package_id",                 :null => false
  end

  create_table "packages", :force => true do |t|
    t.integer "parent_id"
    t.string  "name",      :limit => 256, :null => false
  end

  create_table "scenarios", :force => true do |t|
    t.integer  "feature_id",                :null => false
    t.integer  "position",                  :null => false
    t.string   "title",      :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", :force => true do |t|
    t.integer  "scenario_id",                :null => false
    t.integer  "position",                   :null => false
    t.string   "text",        :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name",       :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
