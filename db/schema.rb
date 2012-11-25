# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121125152709) do

  create_table "activities", :force => true do |t|
    t.string  "name",           :limit => 500
    t.integer "work"
    t.integer "activity_order"
    t.integer "deleted"
    t.integer "category_id"
    t.string  "search_name",    :limit => nil
  end

  create_table "categories", :force => true do |t|
    t.string  "name",           :limit => 500
    t.string  "color_code",     :limit => 50
    t.integer "category_order"
    t.string  "search_name",    :limit => nil
  end

# Could not dump table "fact_index" because of following StandardError
#   Unknown type '' for column 'id'

# Could not dump table "fact_index_content" because of following StandardError
#   Unknown type '' for column 'c0id'

  create_table "fact_index_segdir", :primary_key => "level", :force => true do |t|
    t.integer "idx"
    t.integer "start_block"
    t.integer "leaves_end_block"
    t.integer "end_block"
    t.binary  "root"
  end

  add_index "fact_index_segdir", ["level", "idx"], :name => "sqlite_autoindex_fact_index_segdir_1", :unique => true

  create_table "fact_index_segments", :primary_key => "blockid", :force => true do |t|
    t.binary "block"
  end

  create_table "fact_tags", :id => false, :force => true do |t|
    t.integer "fact_id"
    t.integer "tag_id"
  end

  add_index "fact_tags", ["fact_id"], :name => "idx_fact_tags_fact"
  add_index "fact_tags", ["tag_id"], :name => "idx_fact_tags_tag"

  create_table "facts", :force => true do |t|
    t.integer   "activity_id"
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.string    "description", :limit => nil
    t.datetime  "exported_at"
  end

# Could not dump table "tags" because of following StandardError
#   Unknown type 'BOOL' for column 'autocomplete'

  create_table "version", :id => false, :force => true do |t|
    t.integer "version"
  end

end
