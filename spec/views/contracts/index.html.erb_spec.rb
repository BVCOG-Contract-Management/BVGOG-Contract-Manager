require "rails_helper"

RSpec.describe "contracts/index", type: :view do
  include FactoryBot::Syntax::Methods

  before(:each) do
    contracts = []
    for i in 1..15
      contracts << create(:contract, id: i, entity: create(:entity, id: i), program: create(:program, id: i), point_of_contact: create(:user, id: i), vendor: create(:vendor, id: i))
    end
    @contracts = Kaminari.paginate_array(contracts).page(1).per(10)
    # This assigns a Kaminari.paginate_array object to @contracts,
    # with the first page of 10 contracts.
  end

  it "renders a list of contracts" do
    render
    # This checks that the rendered output contains 10 contracts,
    # which is the number of contracts per page.
    assert_select "tbody>tr", count: 10
  end
end
