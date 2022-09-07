class AddCommentToPrinter < ActiveRecord::Migration
  def change
    add_column :printers, :comment, :text
  end
end
