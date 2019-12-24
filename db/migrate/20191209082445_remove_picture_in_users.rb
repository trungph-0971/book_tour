class RemovePictureInUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :picture
  end
end
