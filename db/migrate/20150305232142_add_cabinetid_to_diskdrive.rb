class AddCabinetidToDiskdrive < ActiveRecord::Migration
  def change
    add_reference :diskdrives, :cabinet, index: true
  end
end
