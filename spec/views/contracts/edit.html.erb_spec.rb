require 'rails_helper'

RSpec.describe "contracts/edit", type: :view do
  before(:each) do
    @contract = assign(:contract, Contract.create!())
  end

  it "renders the edit contract form" do
    render

    assert_select "form[action=?][method=?]", contract_path(@contract), "post" do
    end
  end
end
