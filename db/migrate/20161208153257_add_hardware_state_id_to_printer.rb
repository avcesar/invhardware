class AddHardwareStateIdToPrinter < ActiveRecord::Migration
  def change
    add_reference :printers, :hardware_state, index: true
  end
end
