class CreateTypeServices < ActiveRecord::Migration
  def change
    create_table :type_services do |t|
      t.string :name

      t.timestamps
    end
  end
end
