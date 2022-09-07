class CreateBaseboards < ActiveRecord::Migration
  def change
    create_table :baseboards do |t|
      t.string :product
      t.string :manufacturer
      t.string :serialnumber

      t.timestamps
    end
  end
end
