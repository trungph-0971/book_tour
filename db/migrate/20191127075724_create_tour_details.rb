class CreateTourDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :tour_details do |t|
      t.date :start_time
      t.date :end_time
      t.float :price
      t.integer :people_number
      t.references :tour, foreign_key: true

      t.timestamps
    end
  end
end
