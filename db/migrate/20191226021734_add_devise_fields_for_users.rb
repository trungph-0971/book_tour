class AddDeviseFieldsForUsers < ActiveRecord::Migration[5.1]
  def change
    ## Database authenticatable
    remove_column :users, :password_digest
    add_column :users, :encrypted_password, :string, :null => false, :default => ""

    ## Recoverable
    remove_column :users, :reset_digest
    remove_column :users, :reset_sent_at
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    ## Rememberable
    remove_column :users, :remember_digest
    add_column :users, :remember_created_at, :datetime

    ## Confirmable
    remove_column :users, :activation_digest
    remove_column :users, :activated
    remove_column :users, :activated_at
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
  end
end
