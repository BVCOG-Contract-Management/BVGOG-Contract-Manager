class AddAllReviewToVendors < ActiveRecord::Migration[7.0]
  def change
    add_column :vendors, :all_reviews, :text
  end
end
