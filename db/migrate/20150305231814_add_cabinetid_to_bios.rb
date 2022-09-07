class AddCabinetidToBios < ActiveRecord::Migration
  def change
    add_reference :bios, :cabinet, index: true
  end
end
