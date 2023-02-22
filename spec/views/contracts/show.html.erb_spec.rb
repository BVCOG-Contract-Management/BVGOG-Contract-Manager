require 'rails_helper'

RSpec.describe "contracts/show", type: :view do
  before(:each) do
    @contract = assign(:contract, Contract.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
