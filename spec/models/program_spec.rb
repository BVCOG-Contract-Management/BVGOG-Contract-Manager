require "rails_helper"

RSpec.describe Program, type: :model do
  include FactoryBot::Syntax::Methods

  it "should not save program without name" do
    program = build(:program, name: nil)
    expect { program.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should save program with name" do
    program = build(:program, name: "New Vendor")
    expect { program.save! }.not_to raise_error
  end

  it "should not save program with name longer than 255 characters" do
    program = build(:program, name: "a" * 256)
    expect { program.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not save program with duplicate name" do
    program_one = create(:program, name: "New Vendor")
    program_two = build(:program, name: "New Vendor")
    expect { program_two.save! }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should query all contracts for a program" do
    program = create(:program)
    contract_one = create(:contract, program: program)
    contract_two = create(:contract, program: program)
    expect(program.contracts).to include(contract_one)
    expect(program.contracts).to include(contract_two)
  end
end
