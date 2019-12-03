class ChangeLimitOfDescriptionToTours < ActiveRecord::Migration[5.1]
  def change
    change_column :tours, :description, :text
    change_column :reviews, :content, :text
    change_column :comments, :content, :text
  end
end
