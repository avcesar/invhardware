class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.string :net
      t.string :nameserver
      t.string :domain
      t.string :user
      t.string :password
      t.boolean :active

      t.timestamps
    end
  end
end
