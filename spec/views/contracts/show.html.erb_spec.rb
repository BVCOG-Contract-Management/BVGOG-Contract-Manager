require "rails_helper"

RSpec.describe "contracts/show", type: :view do
  include FactoryBot::Syntax::Methods

  before(:each) do
    @contract = assign(:contract, create(:contract, program: create(:program, id: 1)))
  end

  it "renders attributes in <p>" do
    render
  end
end
