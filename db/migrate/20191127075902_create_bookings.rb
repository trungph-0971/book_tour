class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.integer :status
      t.float :price
      t.integer :people_number
      t.references :tour_detail, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
