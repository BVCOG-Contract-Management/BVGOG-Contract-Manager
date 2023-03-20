class AddAverageRatingToVendors < ActiveRecord::Migration[7.0]
  def change
    add_column :vendors, :average_rating, :float
  end
end
