require "rails_helper"

RSpec.describe Vendor, type: :model do
  fixtures :vendors

  it "should not save vendor without name" do
    vendor = Vendor.new
    expect { vendor.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end
end
