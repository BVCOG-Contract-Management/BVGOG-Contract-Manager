require 'rails_helper'

RSpec.describe "contracts/index", type: :view do
  include FactoryBot::Syntax::Methods

  before(:each) do
    assign(:contracts, [
      create(:contract),
      create(:contract)
    ])
  end

  it "renders a list of contracts" do
    render
  end
end
