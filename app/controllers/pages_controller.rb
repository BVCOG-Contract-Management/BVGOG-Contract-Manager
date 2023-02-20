class PagesController < ApplicationController
  def home
  end
  def vendors
    #debugger
    @vendors = Vendor.select(
    [
      Vendor.arel_table[Arel.star], VendorReview.arel_table[:rating].average.as('average_rating')
    ]
    ).joins(
      Vendor.arel_table.join(VendorReview.arel_table).on(
        Vendor.arel_table[:id].eq(VendorReview.arel_table[:vendor_id])
      ).join_sources
    ).group(Vendor.arel_table[:id]).all
  end
end
