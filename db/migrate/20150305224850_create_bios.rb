class CreateBios < ActiveRecord::Migration
  def change
    create_table :bios do |t|
      t.string :name
      t.string :manufacturer
      t.string :version
      t.string :serialnumber

      t.timestamps
    end
  end
end
