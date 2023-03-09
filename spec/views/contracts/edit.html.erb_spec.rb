require "rails_helper"

RSpec.describe "contracts/edit", type: :view do
  include FactoryBot::Syntax::Methods

  before(:each) do
    @contract = assign(:contract, create(:contract, program: create(:program, id: 1)))
  end

  it "renders the edit contract form" do
    render

    assert_select "form[action=?][method=?]", contract_path(@contract), "post" do
    end
  end
end
