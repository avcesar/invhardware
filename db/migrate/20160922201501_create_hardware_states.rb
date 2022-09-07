class CreateHardwareStates < ActiveRecord::Migration
  def change
    create_table :hardware_states do |t|
      t.string :name

      t.timestamps
    end
  end
end
