class CreatePrinterServices < ActiveRecord::Migration
  def change
    create_table :printer_services do |t|
      t.string :title
      t.integer :state_id
      t.datetime :creation_date
      t.datetime :solution_date
      t.text :problem
      t.text :solution
      t.integer :user_id
      t.integer :solution_user_id
      t.integer :printer_id
      t.integer :typeservice_id

      t.timestamps
    end
  end
end
