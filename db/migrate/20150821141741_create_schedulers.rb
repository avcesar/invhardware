class CreateSchedulers < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.date :next_service_date
      t.integer :cabinet_id
      t.integer :frecuency

      t.timestamps
    end
  end
end
