require "rails_helper"

RSpec.describe Entity, type: :model do
  include FactoryBot::Syntax::Methods

  it "should not save entity without name" do
    entity = build(:entity, name: nil)
    expect { entity.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "should save entity with name" do
    entity = build(:entity, name: "New Vendor")
    expect { entity.save! }.not_to raise_error
  end

  it "should not save entity with duplicate name" do
    entity_one = create(:entity, name: "New Vendor")
    entity_two = build(:entity, name: "New Vendor")
    expect { entity_two.save! }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should query all contracts for a entity" do
    entity = create(:entity)
    contract_one = create(:contract, entity: entity)
    contract_two = create(:contract, entity: entity)
    expect(entity.contracts).to include(contract_one)
    expect(entity.contracts).to include(contract_two)
  end
end
