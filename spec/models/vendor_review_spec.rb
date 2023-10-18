# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VendorReview, type: :model do
  include FactoryBot::Syntax::Methods

  it 'does not save vendor review without user' do
    vendor_review = build(:vendor_review, user: nil)
    expect { vendor_review.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'does not save vendor review without vendor' do
    vendor_review = build(:vendor_review, vendor: nil)
    expect { vendor_review.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'does not save vendor review without rating' do
    vendor_review = build(:vendor_review, rating: nil)
    expect { vendor_review.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'does not save vendor review with invalid rating' do
    vendor_review = build(:vendor_review, rating: 6)
    expect { vendor_review.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'saves vendor review with user, vendor, rating, and description' do
    vendor_review = build(:vendor_review, vendor: create(:vendor), user: create(:user))
    expect { vendor_review.save! }.not_to raise_error
  end

  it 'does not save vendor review with duplicate user-vendor pair' do
    vendor_review_one = create(:vendor_review)
    vendor_review_two = build(:vendor_review, user: vendor_review_one.user, vendor: vendor_review_one.vendor)
    expect { vendor_review_two.save! }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
