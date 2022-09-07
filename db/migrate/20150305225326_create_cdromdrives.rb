class CreateCdromdrives < ActiveRecord::Migration
  def change
    create_table :cdromdrives do |t|
      t.string :name
      t.string :drive

      t.timestamps
    end
  end
end
