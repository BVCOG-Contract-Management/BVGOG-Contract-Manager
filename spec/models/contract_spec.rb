require "rails_helper"

RSpec.describe Contract, type: :model do
  include FactoryBot::Syntax::Methods

  it "should save a factory-generated contract" do
    contract = build(:contract, entity: create(:entity), program: create(:program), vendor: create(:vendor), point_of_contact: create(:user))
    expect { contract.save! }.not_to raise_error
  end

  it "should not save contract without entity" do
    contract = build(:contract, entity: nil)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save contract without program" do
    contract = build(:contract, program: nil)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save contract without vendor" do
    contract = build(:contract, vendor: nil)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save contract without point of contact" do
    contract = build(:contract, point_of_contact: nil)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save contract without title" do
    contract = build(:contract, title: nil)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save contract without starts_at" do
    contract = build(:contract, starts_at: nil)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save contract with ends_at before starts_at" do
    contract = build(:contract, starts_at: Date.today, ends_at: Date.today - 1.day)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save contract without contract_type" do
    contract = build(:contract, contract_type: nil)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save a contract with a title longer than 255 characters" do
    contract = build(:contract, title: "a" * 256)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save a contract with less than 0 amount_dollar" do
    contract = build(:contract, amount_dollar: -1)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save a contract with less than 0 amount initial_term_amount" do
    contract = build(:contract, initial_term_amount: -1)
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save a contract with invalid contract_type" do
    contract = build(:contract, contract_type: "invalid")
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save a contract with invalid contract_status" do
    contract = build(:contract, contract_status: "invalid")
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save a contract with invalid amount_duration" do
    contract = build(:contract, amount_duration: "invalid")
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save a contract with invalid initial_term_duration" do
    contract = build(:contract, initial_term_duration: "invalid")
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save a contract with invalid end_trigger" do
    contract = build(:contract, end_trigger: "invalid")
    expect { contract.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should query all documents for a contract" do
    contract = create(:contract)
    contract_document = create(:contract_document, contract: contract)
    expect(contract.contract_documents).to include(contract_document)
  end
end
