class CreateComputersystems < ActiveRecord::Migration
  def change
    create_table :computersystems do |t|
      t.string :name
      t.string :model
      t.string :manufacturer
      t.string :domain
      t.string :ip
      t.integer :totalphysicalmemory, :limit => 8

      t.timestamps
    end
  end
end
