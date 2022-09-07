class AddCabinetidToVideocontroller < ActiveRecord::Migration
  def change
    add_reference :videocontrollers, :cabinet, index: true
  end
end
