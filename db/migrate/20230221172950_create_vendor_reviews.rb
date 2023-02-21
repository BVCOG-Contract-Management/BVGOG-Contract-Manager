class CreateVendorReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :vendor_reviews do |t|
      t.float :rating
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
