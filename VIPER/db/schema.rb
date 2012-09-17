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

ActiveRecord::Schema.define(:version => 20120916174947) do

  create_table "close_relations", :force => true do |t|
    t.integer  "userid"
    t.integer  "r0"
    t.integer  "r1"
    t.integer  "r2"
    t.integer  "r3"
    t.integer  "r4"
    t.integer  "r5"
    t.integer  "r6"
    t.integer  "r7"
    t.integer  "r8"
    t.integer  "r9"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "records", :force => true do |t|
    t.boolean  "f0"
    t.boolean  "f1"
    t.boolean  "f2"
    t.boolean  "f3"
    t.boolean  "f4"
    t.boolean  "f5"
    t.boolean  "f6"
    t.boolean  "f7"
    t.boolean  "f8"
    t.boolean  "f9"
    t.boolean  "f10"
    t.boolean  "f11"
    t.boolean  "f12"
    t.boolean  "f13"
    t.boolean  "f14"
    t.boolean  "f15"
    t.boolean  "f16"
    t.boolean  "f17"
    t.boolean  "f18"
    t.boolean  "f19"
    t.boolean  "f20"
    t.boolean  "f21"
    t.boolean  "f22"
    t.boolean  "f23"
    t.boolean  "f24"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
