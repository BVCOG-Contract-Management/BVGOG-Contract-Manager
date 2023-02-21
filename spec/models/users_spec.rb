require "rails_helper"

RSpec.describe User, type: :model do
    include FactoryBot::Syntax::Methods

  it "should not save user without email" do
    user = build(:user, email: nil)
    expect { user.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "should not save user without password" do
    user = build(:user, password: nil)
    expect { user.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "should not save user without first name" do
    user = build(:user, first_name: nil)
    expect { user.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "should not save user without last name" do
    user = build(:user, last_name: nil)
    expect { user.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "should save user with email, password, first name, and last name" do
    user = build(:user)
    expect { user.save! }.not_to raise_error
  end

    it "should not save user with duplicate email" do
    user_one = create(:user)
    user_two = build(:user, email: user_one.email)
    expect { user_two.save! }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
