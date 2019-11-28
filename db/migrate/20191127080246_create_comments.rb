class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :content
      t.string :commentable_type
      t.integer :commentable_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
