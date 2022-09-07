class AddCabinetidToOperatingsystem < ActiveRecord::Migration
  def change
    add_reference :operatingsystems, :cabinet, index: true
  end
end
