class AddParamsTransactionIdPurchasedAtToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :notification_params, :text
    add_column :bookings, :transaction_id, :string
    add_column :bookings, :purchased_at, :datetime
  end
end
