# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entity, type: :model do
    include FactoryBot::Syntax::Methods

    it 'does not save entity without name' do
        entity = build(:entity, name: nil)
        expect { entity.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'saves entity with name' do
        entity = build(:entity, name: 'New Vendor')
        expect { entity.save! }.not_to raise_error
    end

    it 'does not save entity with name longer than 255 characters' do
        entity = build(:entity, name: 'a' * 256)
        expect { entity.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not save entity with duplicate name' do
        entity_one = create(:entity, name: 'New Vendor')
        entity_two = build(:entity, name: 'New Vendor')
        expect { entity_two.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'queries all contracts for a entity' do
        entity = create(:entity)
        contract_one = create(:contract, entity:)
        contract_two = create(:contract, entity:)
        expect(entity.contracts).to include(contract_one)
        expect(entity.contracts).to include(contract_two)
    end
end
