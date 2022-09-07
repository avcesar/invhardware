class AddLastnameAndSmtpAndPop3AndPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lastname, :string
    add_column :users, :smtp, :string
    add_column :users, :pop3, :string
    add_column :users, :password, :string
  end
end
