class CreateRevenues < ActiveRecord::Migration[5.1]
  def change
    create_table :revenues do |t|
      t.float :revenue
      t.references :tour_detail, foreign_key: true

      t.timestamps
    end
  end
end
