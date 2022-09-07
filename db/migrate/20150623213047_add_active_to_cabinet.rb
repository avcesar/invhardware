class AddActiveToCabinet < ActiveRecord::Migration
  def change
    add_column :cabinets, :active, :boolean
  end
end
