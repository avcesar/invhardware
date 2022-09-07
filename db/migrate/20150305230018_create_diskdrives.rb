class CreateDiskdrives < ActiveRecord::Migration
  def change
    create_table :diskdrives do |t|
      t.string :model
      t.integer :size, :limit => 8
      t.integer :partitions

      t.timestamps
    end
  end
end
