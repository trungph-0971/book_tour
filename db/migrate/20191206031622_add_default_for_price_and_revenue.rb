class AddDefaultForPriceAndRevenue < ActiveRecord::Migration[5.1]
  def change
    change_column :tour_details , :price , :float ,default: "0.0"
    change_column :bookings , :price , :float ,default: "0.0"
    change_column :revenues , :revenue , :float ,default: "0.0"
  end
end
