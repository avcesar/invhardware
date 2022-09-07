class CreateCabinets < ActiveRecord::Migration
  def change
    create_table :cabinets do |t|
      t.string :serial_number
      t.string :inventory_number

      t.timestamps
    end
  end
end
