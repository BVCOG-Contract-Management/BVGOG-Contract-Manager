# frozen_string_literal: true

class ChangeRatingToFloatInVendorReviews < ActiveRecord::Migration[7.0]
    def change
        change_column :vendor_reviews, :rating, :float
    end
end
