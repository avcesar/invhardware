class CreateNetworkadapters < ActiveRecord::Migration
  def change
    create_table :networkadapters do |t|
      t.string :adaptertype
      t.string :name
      t.string :macaddress
      t.integer :speed, :limit => 8

      t.timestamps
    end
  end
end
