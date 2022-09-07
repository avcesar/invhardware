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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170802212208) do

  create_table "baseboards", force: true do |t|
    t.string   "product"
    t.string   "manufacturer"
    t.string   "serialnumber"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "baseboards", ["cabinet_id"], name: "index_baseboards_on_cabinet_id", using: :btree

  create_table "bios", force: true do |t|
    t.string   "name"
    t.string   "manufacturer"
    t.string   "version"
    t.string   "serialnumber"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "bios", ["cabinet_id"], name: "index_bios_on_cabinet_id", using: :btree

  create_table "cabinet_services", force: true do |t|
    t.string   "title"
    t.integer  "state_id"
    t.datetime "creation_date"
    t.datetime "solution_date"
    t.text     "problem"
    t.text     "solution"
    t.integer  "user_id"
    t.integer  "solution_user_id"
    t.integer  "cabinet_id"
    t.integer  "typeservice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cabinets", force: true do |t|
    t.string   "serial_number"
    t.string   "inventory_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "virtual"
    t.boolean  "active"
  end

  create_table "cdromdrives", force: true do |t|
    t.string   "name"
    t.string   "drive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "cdromdrives", ["cabinet_id"], name: "index_cdromdrives_on_cabinet_id", using: :btree

  create_table "computersystems", force: true do |t|
    t.string   "name"
    t.string   "model"
    t.string   "manufacturer"
    t.string   "domain"
    t.string   "ip"
    t.integer  "totalphysicalmemory", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "computersystems", ["cabinet_id"], name: "index_computersystems_on_cabinet_id", using: :btree

  create_table "desktopmonitors", force: true do |t|
    t.string   "caption"
    t.string   "monitormanufacturer"
    t.integer  "screenheight"
    t.integer  "screenwidth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "desktopmonitors", ["cabinet_id"], name: "index_desktopmonitors_on_cabinet_id", using: :btree

  create_table "diskdrives", force: true do |t|
    t.string   "model"
    t.integer  "size",       limit: 8
    t.integer  "partitions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "diskdrives", ["cabinet_id"], name: "index_diskdrives_on_cabinet_id", using: :btree

  create_table "hardware_states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "networkadapters", force: true do |t|
    t.string   "adaptertype"
    t.string   "name"
    t.string   "macaddress"
    t.integer  "speed",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "networkadapters", ["cabinet_id"], name: "index_networkadapters_on_cabinet_id", using: :btree

  create_table "networks", force: true do |t|
    t.string   "net"
    t.string   "nameserver"
    t.string   "domain"
    t.string   "user"
    t.string   "password"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operatingsystems", force: true do |t|
    t.string   "caption"
    t.string   "csdversion"
    t.integer  "countrycode"
    t.integer  "currenttimezone"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "operatingsystems", ["cabinet_id"], name: "index_operatingsystems_on_cabinet_id", using: :btree

  create_table "physicalmemories", force: true do |t|
    t.integer  "capacity",   limit: 8
    t.integer  "speed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "physicalmemories", ["cabinet_id"], name: "index_physicalmemories_on_cabinet_id", using: :btree

  create_table "printer_services", force: true do |t|
    t.string   "title"
    t.integer  "state_id"
    t.datetime "creation_date"
    t.datetime "solution_date"
    t.text     "problem"
    t.text     "solution"
    t.integer  "user_id"
    t.integer  "solution_user_id"
    t.integer  "printer_id"
    t.integer  "typeservice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "printers", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "portname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "serial_number"
    t.string   "inventory_number"
    t.text     "comment"
    t.integer  "hardware_state_id"
  end

  add_index "printers", ["hardware_state_id"], name: "index_printers_on_hardware_state_id", using: :btree

  create_table "processors", force: true do |t|
    t.string   "name"
    t.string   "caption"
    t.string   "manufacturer"
    t.integer  "currentclockspeed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "processors", ["cabinet_id"], name: "index_processors_on_cabinet_id", using: :btree

  create_table "schedulers", force: true do |t|
    t.date     "next_service_date"
    t.integer  "cabinet_id"
    t.integer  "frecuency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "type_services", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "user"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lastname"
    t.string   "smtp"
    t.string   "pop3"
    t.string   "password"
  end

  create_table "videocontrollers", force: true do |t|
    t.string   "caption"
    t.integer  "adapterram"
    t.string   "infsection"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabinet_id"
  end

  add_index "videocontrollers", ["cabinet_id"], name: "index_videocontrollers_on_cabinet_id", using: :btree

end
