require "rails_helper"

RSpec.describe "contracts/new", type: :view do
  include FactoryBot::Syntax::Methods

  before(:each) do
    assign(:contract, Contract.new())
  end

  it "renders new contract form" do
    render

    assert_select "form[action=?][method=?]", contracts_path, "post" do
    end
  end
end
