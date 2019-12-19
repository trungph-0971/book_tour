class Revenue < ApplicationRecord
  validates :revenue, presence: true
  belongs_to :tour_detail

  def self.to_csv options = {}
    CSV.generate(options) do |csv|
      csv << ["Tour ID"] + ["Tour name"] + column_names
      all.find_each do |revenue|
        csv << [revenue.tour_detail.id] +
               [revenue.tour_detail.tour.name] +
               revenue.attributes.values_at(*column_names)
      end
    end
  end
end
