require "rails_helper"

RSpec.describe Vendor, type: :model do
  include FactoryBot::Syntax::Methods

  it "should not save vendor without name" do
    vendor = build(:vendor, name: nil)
    expect { vendor.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "should save vendor with name" do
    vendor = build(:vendor, name: "New Vendor")
    expect { vendor.save! }.not_to raise_error
  end

  it "should not save vendor with duplicate name" do
    vendor_one = create(:vendor, name: "New Vendor")
    vendor_two = build(:vendor, name: "New Vendor")
    expect { vendor_two.save! }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should query all reviews for a vendor" do
    vendor = create(:vendor)
    vendor_review_one = create(:vendor_review, vendor: vendor)
    vendor_review_two = create(:vendor_review, vendor: vendor)
    expect(vendor.vendor_reviews).to include(vendor_review_one)
    expect(vendor.vendor_reviews).to include(vendor_review_two)
  end
end
