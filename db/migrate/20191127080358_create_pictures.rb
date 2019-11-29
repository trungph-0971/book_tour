class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.string :link
      t.string :pictureable_type
      t.integer :pictureable_id

      t.timestamps
    end
  end
end
