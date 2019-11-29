class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.integer :role
      t.string :provider
      t.string :uid
      t.string :picture

      t.timestamps
    end
  end
end
