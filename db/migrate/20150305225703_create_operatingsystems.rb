class CreateOperatingsystems < ActiveRecord::Migration
  def change
    create_table :operatingsystems do |t|
      t.string :caption
      t.string :csdversion
      t.integer :countrycode
      t.integer :currenttimezone
      t.string :version

      t.timestamps
    end
  end
end
