class CreateVendorReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :vendor_reviews do |t|
      t.integer :rating
      t.string :description
      t.integer :vendor_id
      t.integer :user_id
      t.timestamps
    end
    add_index :vendor_reviews, :vendor_id
    add_index :vendor_reviews, :user_id
  end
end
