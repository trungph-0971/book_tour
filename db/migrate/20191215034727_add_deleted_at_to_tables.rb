class AddDeletedAtToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :tour_details, :deleted_at, :timestamp
    add_column :bookings, :deleted_at, :timestamp
    add_column :tours, :deleted_at, :timestamp
  end
end
