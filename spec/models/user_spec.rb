require "rails_helper"

RSpec.describe User, type: :model do
  include FactoryBot::Syntax::Methods

  it "should not save user without email" do
    user = build(:user, email: nil)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user without password" do
    user = build(:user, password: nil)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user without first name" do
    user = build(:user, first_name: nil)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user without last name" do
    user = build(:user, last_name: nil)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user without level" do
    user = build(:user, level: nil)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user with invalid level" do
    user = build(:user, level: "invalid")
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user with email longer than 255 characters" do
    user = build(:user, email: "a" * 256)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user with first name longer than 255 characters" do
    user = build(:user, first_name: "a" * 256)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user with last name longer than 255 characters" do
    user = build(:user, last_name: "a" * 256)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save user with password longer than 255 characters" do
    user = build(:user, password: "a" * 256)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should save user with email, password, first name, and last name" do
    user = build(:user)
    expect { user.save! }.not_to raise_error
  end

  it "should not save user with duplicate email" do
    email = 'ExampleUser@example.com'
    user1 = create(:user, email: email)
    user2 = build(:user, email: email)

    expect { user2.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should query all reviews for a user" do
    user = create(:user)
    vendor_review_one = create(:vendor_review, user: user)
    vendor_review_two = create(:vendor_review, user: user)
    expect(user.vendor_reviews).to include(vendor_review_one)
    expect(user.vendor_reviews).to include(vendor_review_two)
  end

  it "should query all contracts a user is the point of contact for" do
    user = create(:user)
    contract_one = create(:contract, point_of_contact: user)
    contract_two = create(:contract, point_of_contact: user)
    expect(user.contracts).to include(contract_one)
    expect(user.contracts).to include(contract_two)
  end
end
