class AddDefaultToBookingsStatus < ActiveRecord::Migration[5.1]
  def change
    change_column :bookings , :status , :integer ,default: "1"
  end
end
